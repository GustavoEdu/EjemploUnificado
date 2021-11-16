#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use Encode qw/ decode /;

my $q = CGI->new;
my $departamento = $q->param("departamento");
$departamento = decode("UTF-8", $departamento);
$departamento = uc($departamento);

print $q->header(
  -type => "text/html",
  -charset => "utf-8"
);
print<<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Busquedas de Universidades de Programación Web 1</title>
  <link rel="stylesheet" href="../css/estilos.css">
</head>
<body>
  <h1 class="titulo">Resultados de la Consulta Realizada:</h1>
HTML

#Aplicacion de las Subrutinas
my %universidades = recolectarUniversidades($departamento);

#Mostramos la Informacion Recolectada en Forma de una Tabla
print<<HTML;
<table>
  <tr>
    <th>Código Entidad</th>
    <th>Universidad Encontrada</th>
    <th>Tipo Gestion</th>
    <th>Estado Licenciamiento</th>
    <th>Periodo Licenciamiento [Años]</th>
    <th>Numero de Carreras (Entre Pregrado y Posgrado)</th>
  </tr>
HTML
mostrarArreglo(%universidades);
print "</table>";

#Se imprime la cola del texto HTML
print<<HTML;
    <br>
    Ingrese <a href="../consulta.html">aqui</a> para regresar al formulario de busqueda
  </body>
</html>
HTML

#Subrutina que devuelve un array de Strings de Universidades segun Region
sub recolectarUniversidades {
  my $str = $_[0];
  
  #Leyendo todas las lineas del Archivo
  open(IN, "< :encoding(Latin1)", "Programas de Universidades.csv") or die "cant't binmode to encoding Latin1";
  binmode(IN, ":encoding(Latin1)") || die "can't binmode to encoding Latin1";
  my @arreglo = <IN>; 
  close(IN);
  
  my $size = contarColumnas($arreglo[0]);
  my $pattern = construirRegExp($size);

  my %universidades = ();
  foreach my $linea (@arreglo) {
    if($linea =~ /$pattern/) {
      my $departamento = $11; 
      my $universidad = $2;
      if($departamento eq $str) {
        my $cont = $universidades{$universidad};
        if(!defined($cont)) {
          $universidades{$universidad} = 1;
        } else {
        $cont++;
        $universidades{$universidad} = $cont;
        } 
      }
    }
  }
  return %universidades;
}

#Subrutina que muestra el resultado de la consulta, ademas de
#transformarlo en texto HTML 
sub mostrarArreglo {
  #Leyendo todas las lineas del Archivo
  open(IN, "< :encoding(Latin1)", "Programas de Universidades.csv") or die "cant't binmode to encoding Latin1";
  binmode(IN, ":encoding(Latin1)") || die "can't binmode to encoding Latin1";
  my @arreglo = <IN>;
  close(IN);

  my $size = contarColumnas($arreglo[0]);
  my $pattern = construirRegExp($size);

  my %dict = @_;
  foreach my $universidad (keys %universidades) {
    print "<tr>\n";
    my %uni = recolectarInformacion($universidad);
    print "<td>$uni{'codigo'}</td>\n"; 
    print "<td>$universidad</td>\n";
    print "<td>$uni{'tipoGestion'}</td>\n";
    print "<td>$uni{'estadoLicenciamiento'}</td>";
    print "<td>$uni{'periodoLicenciamiento'}</td>";
    print "<td>$universidades{$universidad}</td>\n";
    print "</tr>\n";
  }
}

#Recolectando toda la Información sobre una Universidad a través de una
#clave foránea, la cual en este caso fue conveniente que fuese el
#nombre de la Universidad en cuestión, aunque también pudo haber sido
#el Código Entidad
sub recolectarInformacion {
  my $universidad = $_[0];
  
  #Leyendo todas las lineas del Archivo
  open(IN, "< :encoding(Latin1)", "Programas de Universidades.csv") or die "cant't binmode to encoding Latin1";
  binmode(IN, ":encoding(Latin1)") || die "can't binmode to encoding Latin1";
  my @arreglo = <IN>;
  close(IN);
  
  my $size = contarColumnas($arreglo[0]);
  my $pattern = construirRegExp($size);

  my %uni = ();
  foreach my $line (@arreglo) {
    if($line =~ /$pattern/) {
      my $nombre = $2;
      if($nombre eq $universidad) {
        my $codigo = $1;
        $uni{"codigo"} = $codigo;
        my $tipoGestion = $3;
        $uni{"tipoGestion"} = $tipoGestion;
        my $estadoLicenciamiento = $4;
        $uni{"estadoLicenciamiento"} = $estadoLicenciamiento; 
        my $periodoLicenciamiento = $5;
        $uni{"periodoLicenciamiento"} = $periodoLicenciamiento;
        last;
      }
    }
  } 
  return %uni;
}

#Subrutina que cuenta el Numero de Columnas del Encabezado
sub contarColumnas {
  my $line = $_[0];
  my $counter = 1;
  while($line =~ /^([^\|]+)\|(.+)/){
    $counter++;
    $line = $2;
  }
  return $counter;
}

#Subrutina que construye la Expresion Regular segun Extension
sub construirRegExp {
  my $num = $_[0]; 
  my $s = "^";
  for(my $i = 1; $i < $num; $i++) {
    $s .= '([^\|]+)\|';
  }
  $s .= '([^\|]+)';
  return $s;
}

