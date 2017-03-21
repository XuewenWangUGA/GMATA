#!/usr/bin/perl -w
use strict;
&usageinfo();
#usage: # perl elctPCR.pl -i testseq.fasta -o emap_tag -mk "testseq.fasta.ssr.finalPrimer.txt.sts" -pf u|w -w wordsize -f discontiguous -m maxoffsts  -d amplicomsizerange  -n maximismatch -g maxigapindel -p hitgroup 
my %commandin = @ARGV;
if ((scalar @ARGV)%2 != 0){print "arguments must be in pair";}
my $refin=$commandin{"-i"}; #sequence file, standard  fasta format in 2 or multiple lines
my $finalprimersts=$commandin{"-mk"}; #final Primer (marker) sts file name 
my $outputtag=$commandin{"-o"}||"eMap";
my $outputfile=$refin."\.".$outputtag;
my $markerAmplicon=$outputfile."\.amp";
my $mAmpliconfragments=$outputfile."\.frg";
my $platformrun=$commandin{"-pf"}||"u";#platform u for unix, w for windows
my $hitgroup=$commandin{"-p"}||'-';
my $maximismatch=$commandin{"-n"}||0;
my $maxigapindel=$commandin{"-g"}||0;
my $maxoffsts=$commandin{"-m"}||3000;
my $amplicomsizerange=$commandin{"-d"}||"100-1000";#amplicon size range
my $discontiguous=$commandin{"-f"}||1;# value 1 or 3. discontiguous 1 for contiguous, 3 for not 
my $wordsize=$commandin{"-w"}||12;#wordsize
 unless(-e $refin){print "sequence fasta file does not exist in the working directoty\n";}
 unless(-e $finalprimersts){print "sts file does not exist in the working directoty\n";}
 print "To do marker ePCR, marker allels counting.\n";
 print "parameters: w=$wordsize f=$discontiguous pf=$platformrun m=$maxoffsts n=$maximismatch g=$maxigapindel d=$amplicomsizerange p=$hitgroup, \n Output files: \n $outputfile \n $markerAmplicon\n $mAmpliconfragments\n";
 print formatedrealtime(); 
 open(OUT, ">$outputfile")|| die (" Write file failed, pleasse check");
 my @par=();
 @par=('-w', $wordsize, '-f', $discontiguous, '-m', $maxoffsts, '-d', $amplicomsizerange, '-n', $maximismatch, '-g' ,$maxigapindel, '-t', '3', '-p', $hitgroup, '-o', $outputfile, $finalprimersts, $refin);
 my $go='';
 my @argrun=();
	if ($platformrun eq "w"){
		$go='e-PCR.exe';				
	}elsif($platformrun eq "u"){
		$go='e-PCR';
	}
	@argrun=($go, @par);
	system(@argrun)==0 or die ("system call failed: $?");
@par=('eparsing.pl','-i', $outputfile,  '-o', $markerAmplicon);
$go="perl" ;	
@argrun=($go, @par);
system(@argrun)==0 or die ("system call failed: $?");

@par=('fragct.pl','-i', $markerAmplicon,  '-o', $mAmpliconfragments);
$go='perl';	
@argrun=($go, @par);
system (@argrun)==0 or die ("system call failed: $?");
close OUT;
sub usageinfo
 {
 my @usage=(); 
 $usage[0]="Functions: using marker information (sts format) to do ePCR in a sequence file (fasta) to get the marker-amplicons-seq information, marker-allele number for each marker.\n";
 $usage[1]=" for    help: perl $0 ; \n";
 $usage[2]=" for running: perl $0 -i \{seq_file_fasta\} -mk \{seq_file\}.ssr.finalPrimer.txt.sts \[-o emap_tag\] \[-pf u|w\] \[-w wordsize\] \[-f discontiguous\] \[-m maxoffsts\]  \[-d amplicomsizerange\]  \[-n maximismatch\] \[-g maxigapindel\] \[-p hitgroup\]\n\n";
 $usage[3]="e.g. perl elctPCR.pl -i testseq.fasta -mk testseq.fasta.ssr.finalPrimer.txt.sts\n";
 $usage[4]="Author: Xuewen Wang\n";
 $usage[5]="year 2010-2013, Nov\n";
 unless(@ARGV){print @usage; exit;} 
 }
sub formatedrealtime {
my @weekday = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");
my $local_time = gmtime();
my $runtime= "results yielded at $local_time\n\n";
return $runtime;
}
exit;
