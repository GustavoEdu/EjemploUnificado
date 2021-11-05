#!/usr/bin/perl
use strict;
use warnings;

open(IN, "Programas de Universidades.csv") or die("Error al abrir el archivo");
my $line = <IN>;
my $counter = 0;
while($line =~ /^([^\|]+)\|(.+)/){
  print "[$counter] $1\n";
  $counter++;
  $line = $2;
}
close(IN);
