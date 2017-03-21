#!/usr/bin/perl -w
use strict;
&usageinfo();
my %commandin = @ARGV;
if ((scalar @ARGV)%2 != 0){print "arguments must be in pair";}
my $refin=$commandin{"-i"}; #information of input sequence file
my $fmseqfile=$refin.".fms"; 
my $ssrfile=$refin.".ssr"; 
my $ssrfiletmp=$refin.".ssrtmp";
my $motifmin=$commandin{"-m"}||2;
my $motifmax=$commandin{"-x"}||10; 
my $motif_times_min=$commandin{"-r"}||5; 
my $seqhight=$commandin{"-s"}||0; 
open (OUTLOG,">info.log")|| die (" LOG file writing failed, please check");
&runtime(\*OUTLOG);
print OUTLOG "In this run, parameters setting are: -r $motif_times_min -m $motifmin -x $motifmax -s $seqhight -i $refin\n";
print "Please wait during formating...\n\n"; #command line run information
system ("perl formatchunk.pl  -i $refin -f 1 -len 0 -o $fmseqfile")==0 or die ("system call failed: $?");
my $fileinfo1= "Sequences were successfully formatted. 
file: $fmseqfile.
file: $refin.fms.sat1\n\n";
print OUTLOG $fileinfo1;
print $fileinfo1;
&runtime(\*OUTLOG);
print "Mining microsatellite...\n";
system ("perl gssr.pl -r $motif_times_min -m $motifmin -x $motifmax -s $seqhight -i $fmseqfile -o $ssrfiletmp")==0 or die ("system call failed: $?");
system ("perl gssrtrim.pl -i $ssrfiletmp -o $ssrfile")==0 or die ("system call failed: $?");
my $fileinfo2="Microsatellite data were provided.
file:  $ssrfile\n\n";
print OUTLOG $fileinfo2;
print $fileinfo2;
print "Statistical Analysing...\n";
&runtime(\*OUTLOG);
system ("perl gsts.pl -i $ssrfile")==0 or die ("system call failed: $?");
my $fileinfo3="statistic results were provided.
file:  $refin.sat2\n\n";
print OUTLOG $fileinfo3;
print $fileinfo3;
print "Done.\n";
&runtime(\*OUTLOG);
sub usageinfo
	{
	my @usage=(); 
	$usage[0]="Usage: searching the repeated motif such as SSR in a genome sequence file.\n";
	$usage[1]=" for    help: perl $0 ; \n";
	$usage[2]=" for running: perl $0 -i sequence_file  \[-r minimum_repeated_times\] 
	\[-m minimum_motif_length\] \[-x maximum_motif_length\] \[-s highlight_motif_in_sequence_0_or_1\]\n";
	$usage[3]=" e.g.: perl gmat.pl -i testseq.fasta \n";
	$usage[4]="Author: Xuewen Wang\n";
	$usage[5]="year 2012, 2013 Nov\n";
	unless(@ARGV){print @usage; exit;} 
 }
sub runtime(){
	my $OUTfile=${shift @_};
	my $local_time = gmtime();
	print {$OUTfile} "$0 was run. Current time is $local_time\n";
}
exit;
