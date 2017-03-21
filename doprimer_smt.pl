#!/usr/bin/perl -w
use strict;
#usage: perl doprimer_smt.pl -i InputSequenceFile.fasta -sr ssrFilename -p platformType_u:Unix_w:windows  -fl flanksize_Size -l maxiTemplateLength -ts OutputTemplateSeq_T/F -smin minimumSizeAmplicon -Smax maximumSizeAmplicon -tm Optimal_PCRannealTm -dir directory_installed_Primer3_UnixOnly
# e.g. perl doprimer_smt.pl -i InputSequenceFile.fasta -sr ssrFilename -p w -fl 200 -l 2000 -ts F -smin 120 -Smax 400 -tm 60 -dir '/home/SCE/wangxuewen/bin/primer3-2.2.3/src'

if ((scalar @ARGV)== 0){print  usageinfo(); exit;}
print "To design PCR Primers, Markers for SSR loci and produce statistics.\n\n";
my %commandin = @ARGV; 
  if ((scalar @ARGV)%2 != 0){print "arguments must in pair";} 
  my $file=$commandin{"-i"};
  my $ssrfile=$commandin{"-sr"};
  my $platformsystype=$commandin{"-p"}||"w"; 
  my $flseq=$commandin{"-fl"}||200;
  my $maxtemplate=$commandin{"-l"}||2000;
  my $templseq=$commandin{"-ts"}||"F";
  my $minamplicon=$commandin{"-smin"}||120;
  my $maxamplicon=$commandin{"-Smax"}||400;
  my $opti_tm=$commandin{"-tm"}||60;
  my $directorPrimcore=$commandin{"-dir"}||'/primer3-2.2.3/src';
  my $name_mk=$commandin{"-n"}||"MK";
my $seqfile=$file;
my $seqfilefms=$seqfile.".fms";
my $rangefile=$seqfile.".range";	
my $sub_template=$seqfile.".seq";
my $primer_out=$ssrfile.".primer_out";
my $primer_temp=$primer_out."\.temp";
my $primerfinal=$ssrfile.".mk";
my @par=();
@par=("perl","rangefile_maker.pl",'-i', $ssrfile, '-fl', $flseq, '-o', $rangefile);
system (@par)==0 or die ("system call failed: $?");
system("perl readfasta_n.pl -i $seqfile -f 1 -len F -id T -o $seqfilefms")==0 or die ("system call failed: $?");
system ("perl substring_SSR_smt.pl -o $sub_template -s $seqfilefms -r $rangefile -l $maxtemplate")==0 or die ("system call failed: $?");
system ("perl designPrimer.pl -i $sub_template -p $platformsystype -tm $opti_tm -smin $minamplicon -Smax $maxamplicon -dir $directorPrimcore -o $primer_out")==0 or die ("system call failed: $?");
system ("perl formatPrimers.pl -ts $templseq -i $primer_out -o $primerfinal")==0 or die ("system call failed: $?");
sub usageinfo
 {
 my @usage=(); 
 $usage[0]="Usage: extract SSR loci flanks, and design primers, markers.\n";
 $usage[1]=" for    help: perl $0 ; \n";
 $usage[2]=" for running: perl $0 -i InputSequenceFile.fasta -sr ssrFilename \[-p platformType_u:Unix_w:windows\]  \[-fl flanksize_Size\] \[-l maxiTemplateLength\] \[-ts OutputTemplateSeq_T/F\] \[-smin minimumSizeAmplicon\] \[-Smax maximumSizeAmplicon\] \[-tm Optimal_PCRannealTm\] \[-dir directory_installed_Primer3_UnixOnly\]\n\n"; 
 $usage[3]="e.g.: perl doprimer_smt.pl -i testseq.fasta -sr testseq.fasta.ssr\n";
 $usage[4]="Author: Xuewen Wang\n";
 $usage[5]="year 2012, 2013, Nov\n\n";
 return @usage; 
 }
unlink $primer_out, $rangefile;
unlink $seqfilefms;
exit;
	