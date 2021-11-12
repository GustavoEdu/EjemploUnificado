#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $q = CGI->new;
my $departamento = uc($q->param("departamento"));
print $q->header("text/html");
print<<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Busquedas de Universidades de Programación Web 1</title>
  <link rel="stylesheet" href="../css/estilos.css">
</head>
<body>
  <h1>Resultados de la Consulta Realizada:</h1>
HTML

#Aplicacion de las Subrutinas
my %universidades = recolectarUniversidades($departamento, "Programas de Universidades.csv");

#Mostramos la Informacion Recolectada en Forma de una Tabla
print<<HTML;
<table>
  <tr>
    <th>Universidad Encontrada</th>
    <th>Numero de Carreras (Entre Pregrado y Posgrado)</th>
  </tr>
HTML
mostrarArreglo(%universidades);
print "</table>";

#Se imprime la cola del texto HTML
print<<HTML;
    Ingrese <a href="../consulta.html">aqui</a> para regresar al formulario de busqueda
  </body>
</html>
HTML

#Subrutina que devuelve un array de Strings de Universidades segun Region
sub recolectarUniversidades {
  my $str = $_[0];
  my $fileName = $_[1];
  
  #Leyendo todas las lineas del Archivo
  open(IN, $fileName) or die("Error al abrir el Archivo!!!");
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
  my %dict = @_;
  foreach my $universidad (keys %universidades) {
    print "<tr>\n";
    print "<td>$universidad</td>\n";
    print "<td>$universidades{$universidad}</td>\n";
    print "</tr>\n";
  }
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

