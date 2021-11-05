#!/usr/bin/perl
use strict;
use warnings;

open(IN, "Programas de Universidades.csv") or die("Error al abrir el archivo");
my @arr = <IN>;
close(IN);

my $size = leerEncabezado();
my $pattern = construirRegExp($size);
#print "$pattern\n"; 
if($arr[1] =~ /$pattern/) { 
  #  print "$19\n";
  #  print "$2\n";
  #  print "$4\n";
  #  print "$17\n";
}
else {
  print "$arr[1]\n";
}

my %unis = ();

foreach my $linea (@arr) {
  if($linea =~ /$pattern/ && $11 eq "AREQUIPA") {
    #      print "$2\n";
    $unis{$2} = "";
  }
}
foreach my $uni (keys %unis) {
  print "$uni\n";
}

sub leerEncabezado {
  my $line = $arr[0];
  my $counter = 1;
  while($line =~ /^([^\|]+)\|(.+)/){
    print "[$counter] $1\n";
    $counter++;
    $line = $2;
  }
  print "[$counter] $line\n";
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

