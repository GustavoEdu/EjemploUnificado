#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $q = CGI->new;
my $region = $q->param("lugar");
print $q->header("text/html");
print<<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Resultados de la Consulta</title>
</head>
<body>
  <h1>Resultados de la Consulta:</h1>
HTML

#Leyendo todo el archivo en un arreglo de Strings
open(IN, "Programas de Universidades.csv") or die("Error al abrir el archivo");
my @arr = <IN>;
close(IN);

#Aplicacion de las Subrutinas
my %universidades = recolectarUniversidades($region, "Programas de Universidades.csv");
mostrarArreglo(%universidades);

#Se imprime la cola del texto HTML
print<<HTML;
</body>
</html>
HTML

#Subrutina que devuelve un array de Strings de Universidades segun Region
sub recolectarUniversidades {
  my $str = $_[0];
  my $fileName = $_[1];

  open(FILE, $fileName) or die("Error al abrir el Archivo!!!");
  my @arreglo = <FILE>; 
  close(FILE);
  
  my $size = contarColumnas($arreglo[0]);
  my $pattern = construirRegExp($size);

  my %universidades = ();
  foreach my $linea (@arreglo) {
    if($linea =~ /$pattern/) {
      my $departamento = $11; 
      my $universidad = $2;
      if($departamento eq "AREQUIPA") {
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
    print "<p>$universidad: $universidades{$universidad}</p>\n";
  }
}

#Subrutina que cuenta el Numero de Columnas del Encabezado
sub contarColumnas {
  my $line = $arr[0];
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

