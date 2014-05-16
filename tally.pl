#!/usr/bin/perl

use File::Copy;

# Programa para acumular puntos/asistencias según la lista de matrículas registradas en el curso.
# Recibe como argumentos:
# 	Un archivo con una lista de participaciones por cada estudiante, indexados por número de matrícula  
#	Un segundo archivo con una lista de matrículas (una por línea) de los estudiantes que han colaborado en dicha sesión/ejercicio.

open(LISTA, $ARGV[0]) or die("No se encontró el archivo.");
my %estudiantes = ();
# Llenando el hash indexado por número de matrícula con las actividades previas.
foreach $estudiante (<LISTA>){
	$estudiante =~ /([0-9]{9}),(.*)/;
	$estudiantes{$1} = $2;
	#print "$1, $2\n";
}
close(LISTA);

# Abrimos el segundo archivo que contiene una lista de matriculas de los estudiantes que han participado en la actividad. El nombre del archivo se utilizará como descriptor de la actividad realizada (puede ser solo la fecha de la sesión en el caso de querer listar asistencia).
open (NUEVA_ACTIVIDAD, $ARGV[1]) or die("No se encontró el archivo.");

foreach $estudiante (<NUEVA_ACTIVIDAD>){
	$estudiante =~ s/^\s+|\s+$//g;
	$estudiantes{$estudiante} .= "$ARGV[1]," if exists $estudiantes{$estudiante} && $estudiantes{$estudiante}!~/$ARGV[1]/;
#	print "$estudiante, Actividades: $estudiantes{$estudiante}\n" if exists $estudiantes{$estudiante};
}
close(LISTA);

# Hacemos un backup del archivo original en caso de que se dañe por algún error en el proceso de sobreescritura a continuación.
$n = 1;
$n++ while (-e "$ARGV[0]_backup$n");
copy($ARGV[0], $ARGV[0]."_backup$n") or die("No se pudo hacer backup del archivo.");

# Se vuelve a abrir el archivo con la lista, ahora en modo reescritura (ya tenemos cargados los datos originales en el hash y hecho un backup).
open(LISTA, ">$ARGV[0]") or die("No se puede reescribir el archivo.");
while( my ($k,$v) = each %estudiantes ) {
	print LISTA "$k,$v\n";
}
close LISTA;
