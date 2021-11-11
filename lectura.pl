#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $q = CGI->new;
my $lugar = $q->param("lugar");
print $q->header("text/html");
print<<BLOCK;
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Resultados de la Consulta</title>
</head>
<body>
  <h1>Resultados de la Consulta:</h1>
BLOCK

#Leyendo todo el archivo en un arreglo de Strings
open(IN, "Programas de Universidades.csv") or die("Error al abrir el archivo");
my @arr = <IN>;
close(IN);

my $size = leerEncabezado();
my $pattern = construirRegExp($size);
print STDERR "$pattern\n"; #Se verifica si el patron generado es correcto

#my %unis = ();
#foreach my $linea (@arr) {
#if($linea =~ /$pattern/ && $11 eq "AREQUIPA") {
#print "$2\n"; Hay repeticion de los nombres
#$unis{$2} = "";
#}
#}

#Se recorre todo el Archivo, linea por linea
#foreach my $linea (@arr) {
#  if($linea =~ /$pattern/) {
#    my $departamento = $11; 
#    my $universidad = $2;
#    if($departamento eq "AREQUIPA") {
#      my $cont = $unis{$universidad};
#      if(!defined($cont)) {
#        $unis{$universidad} = 1;
#      } else {
#        $cont++;
#        $unis{$universidad} = $cont;
#      }
#    }
#  }
#}

#my $sum = 0;
#foreach my $universidad (keys %unis) {
#  my $num_carreras = $unis{$universidad};
#  print "$universidad:$num_carreras\n"; #STDOUT
  #$sum += $unis{$uni};
  #}
#print "$sum\n";

  #my @array = mostrarUnisPorDepartamento("CUSCO", "Programas de Universidades.csv");

  #print "Introduzca el nombre de una Region: ";
  #my $region = <STDIN>; 
  #chomp($region);
  #print "Universidades que tiene sede en la Region $region:\n";
my @array = mostrarUnisPorDepartamento($lugar, "Programas de Universidades.csv");
foreach my $university (@array) {
  print "<p>$university</p>\n";
}

print<<HTML;
</body>
</html>
HTML

sub mostrarUnisPorDepartamento() {
  my $str = $_[0];
  my $fileName = $_[1];

  open(FILE, $fileName) or die("Error al abrir el Archivo!!!");
  my @arreglo = <FILE>; 
  close(FILE);

  my %universidades = ();

  foreach my $line (@arreglo) {
    if($line =~ /$pattern/) {
      my $departamento = $11; 
      my $universidad = $2;
      if($departamento eq $str) {
        $universidades{$universidad} = "";
      }
    }
  }
  my @lista;
  foreach my $uni (keys %universidades) {
    push(@lista, $uni);
  }
  return @lista;
}

sub leerEncabezado {
  my $line = $arr[0];
  my $counter = 1;
  while($line =~ /^([^\|]+)\|(.+)/){
    print  STDERR "[$counter] $1\n";
    $counter++;
    $line = $2;
  }
  print STDERR "[$counter] $line\n";
  #print "$counter\n";
  return $counter;
}
sub construirRegExp {
  my $num = $_[0]; 
  my $s = "^";
  for(my $i = 1; $i < $num; $i++) {
    $s .= '([^\|]+)\|';
  }
  $s .= '([^\|]+)';
  return $s;
}

