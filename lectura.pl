#!/usr/bin/perl
use strict;
use warnings;

open(IN, "Programas de Universidades.csv") or die("Error al abrir el archivo");
my $line = <IN>;
while($line =~ /^([^\|]+)\|(.+)/){
  print "$1\n";
  $line = $2;
}
close(IN);
