#!/usr/bin/perl -w
use strict;
& usageinfo;
my %commandin = @ARGV;
if ((scalar @ARGV)%2 != 0){print "arguments must be in pair";}
my $refin=$commandin{"-i"}; #file, testseq.ssr.sat2, suffix .ssr.sat2
my $outputfile=$refin;
my $barf1=$commandin{"-f1"}||10;
my $barf2=$commandin{"-f2"}||20;
my $barf3=$commandin{"-f3"}||20;
my $barf4=$commandin{"-f4"}||10;
my $barf5=$commandin{"-f5"}||20;
my $block=1;
 unless(-e $refin){print "sequence fasta file does not exist in the working directoty\n";}
print "Plotting statistical graphics. \n Output files: \n 12 figures ending with .jpg\n"; 
local $/="\nTable";
open(FILE, $refin)|| die (" input file failed, pleasse check");	
	$outputfile =~ s/\.ssr\.sat2//;
	my $outtablefileb="$outputfile.t4b";
	my $outtablefilec="$outputfile.t4c";
	open(OUTb, ">$outtablefileb")|| die (" Write file failed, please check");
	open(OUTc, ">$outtablefilec")|| die (" Write file failed, please check");
while (my $seqinfo = <FILE>) {
	chomp $seqinfo;
	my $seqinfo_full=$seqinfo;
	$seqinfo =~ s/total_above\ttotal_above\ttotal_above.*\n.+$//;
	my $outtablefile="$outputfile.t$block";
	my $outtablefileall="$outputfile.t$block.all";
	my $outtablefilefull="$outputfile.t$block.full";
	open(OUT, ">$outtablefile")|| die (" Write file failed, pleasse check");
	open(OUTall, ">$outtablefileall")|| die (" Write file failed, pleasse check");
	open(OUTfull, ">$outtablefilefull")|| die (" Write file failed, pleasse check");
	unless($seqinfo =~ m/^gsts.pl was run/){
		print OUTfull $seqinfo_full,"\n";
		my @contents=split("\n", $seqinfo);
		my $vshift=shift @contents;#remove number etc resulting from "Table" line #
		my $lineout=0;
		my $ii=1;
	if($block==1){
		$lineout=$barf1+1; 
	}elsif($block==2){
		$lineout=$barf2+1; 
	}elsif($block==3){
		$lineout=$barf3+1; 
	}elsif($block==4){
		$lineout=$barf4+1; 
	}elsif($block==5){
		$lineout=$barf5+1; 
	}
	foreach my $linec(@contents){
		(print OUT $linec,"\n" ) if ($ii<=$lineout); #control how many lines to output in each block
		$ii++;
		print OUTall $linec,"\n"; # output all data in each block
		if($block==4 ){
			my @lcells=split("\t", $linec);			
			print (OUTb $lcells[0], "\t",$lcells[4],"\n" )if ($ii<=$lineout); #frequency			
			print (OUTc $lcells[0], "\t",$lcells[1],"\t",$lcells[3],"\n" )if ($ii<=$lineout); #ID, loci count, Seqlength
		}
	} #end foreach
	close OUT;
	close OUTall;
	close OUTfull;
	$block++;
	}
} #end while
close OUTb;
close OUTc;

#outfig
my $figout=$outputfile; 
my $figtag="";

my $D3_input=$outtablefileb;
my $D3_title="\"D3. Top SSR frequencies on chromosomes\"";
my $D3_xlabdir=2;
my $D3_ylabcontent="\"Frequency(count/Mb)\"";
my $D3_addtext=0;
my $D3_xlabcontent="\"\"";
$figtag="D3.TopSsrFreqChr";
my $fig_filename=$figout."\.Fig.".$figtag;
my $D3=join(' ', "Rscript ssrfig.r",$D3_input,$D3_title,$D3_xlabdir,$D3_ylabcontent,$D3_addtext,$D3_xlabcontent,$fig_filename);
system($D3);
$D3_input=$outputfile.".t1";
$D3_title="\"A2. Top k-mers\"";
$D3_xlabdir=1;
$D3_ylabcontent="\"Total occurrence\"";
$D3_addtext=1;
$D3_xlabcontent="\"Mers\"";
$figtag="A2.TopKmers";
$fig_filename=$figout."\.Fig.".$figtag;
$D3=join(' ', "Rscript ssrfig.r",$D3_input,$D3_title,$D3_xlabdir,$D3_ylabcontent,$D3_addtext,$D3_xlabcontent,$fig_filename);
system($D3);
$D3_input=$outputfile.".t2";
$D3_title="\"B2. Top motifs\"";
$D3_xlabdir=2;
$D3_ylabcontent="\"Total occurrence\"";
$D3_addtext=1;
$D3_xlabcontent="\"Motif\"";
$figtag="B2.TopMotif";
$fig_filename=$figout."\.Fig.".$figtag;
$D3=join(' ', "Rscript ssrfig.r",$D3_input,$D3_title,$D3_xlabdir,$D3_ylabcontent,$D3_addtext,$D3_xlabcontent,$fig_filename);
system($D3);
$D3_input=$outputfile.".t3";
$D3_title="\"C2. Top grouped motifs\"";
$D3_xlabdir=2;
$D3_ylabcontent="\"Total occurrence\"";
$D3_addtext=1;
$D3_xlabcontent="\"\"";
$figtag="C2.TopGroupedMotif";
$fig_filename=$figout."\.Fig.".$figtag;
$D3=join(' ', "Rscript ssrfig.r",$D3_input,$D3_title,$D3_xlabdir,$D3_ylabcontent,$D3_addtext,$D3_xlabcontent,$fig_filename);
system($D3);

$D3_input=$outputfile.".t4";
$D3_title="\"D2. Top SSR loci on chromosomes\"";
$D3_xlabdir=2;
$D3_ylabcontent="\"Total occurrence\"";
$D3_addtext=0;
$D3_xlabcontent="\"\"";
$figtag="D2.TopSsrLociChr";
$fig_filename=$figout."\.Fig.".$figtag;
$D3=join(' ', "Rscript ssrfig.r",$D3_input,$D3_title,$D3_xlabdir,$D3_ylabcontent,$D3_addtext,$D3_xlabcontent,$fig_filename);
system($D3);

$D3_input=$outputfile.".t5";
$D3_title="\"E2. Top distribution of SSR length\"";
$D3_xlabdir=2;
$D3_ylabcontent="\"Total occurrence\"";
$D3_addtext=1;
$D3_xlabcontent="\"SSR length\"";
$figtag="E2.TopSsrLength";
$fig_filename=$figout."\.Fig.".$figtag;
$D3=join(' ', "Rscript ssrfig.r",$D3_input,$D3_title,$D3_xlabdir,$D3_ylabcontent,$D3_addtext,$D3_xlabcontent,$fig_filename);
system($D3);

$D3_input=$outputfile.".t4c";
$D3_title="\"D4. SSRs count vs sequence length\"";
$D3_xlabdir=2;
$D3_ylabcontent="\"Sequence length \(bp\)\"";
$D3_xlabcontent="\"SSR loci count\"";
$figtag="D4.SsrCtVsSeqLength";
$fig_filename=$figout."\.Fig.".$figtag;
$D3=join(' ', "Rscript ssrfigxy.r",$D3_input,$D3_title,$D3_xlabdir,$D3_ylabcontent,$D3_xlabcontent,$fig_filename);
system($D3);

$D3_input=$outputfile."\.t1\.all";
$D3_title="\"A1. K-mer distribution of motifs\"";
$D3_xlabcontent="\"\-mer\"";
$D3_addtext="\"T\"";
$figtag="A2.KmerDistr";
$fig_filename=$figout."\.Fig.".$figtag;
$D3=join(' ', "Rscript ssrpie.r",$D3_input,$D3_title,$D3_xlabcontent,$D3_addtext,$fig_filename);
system($D3);

$D3_input=$outputfile."\.t2\.all";
$D3_title="\"B1. Motif distribution\"";
$D3_xlabcontent="\"\"";
$D3_addtext="\"T\"";
$figtag="B1.MotifDistr";
$fig_filename=$figout."\.Fig.".$figtag;
$D3=join(' ', "Rscript ssrpie.r",$D3_input,$D3_title,$D3_xlabcontent,$D3_addtext,$fig_filename);
system($D3);

$D3_input=$outputfile."\.t3\.all";
$D3_title="\"C1. Grouped motif distribution\"";
$D3_xlabcontent="\"\"";
$D3_addtext="\"T\"";
$figtag="C1.GroupedMotifDistr";
$fig_filename=$figout."\.Fig.".$figtag;
$D3=join(' ', "Rscript ssrpie.r",$D3_input,$D3_title,$D3_xlabcontent,$D3_addtext,$fig_filename);
system($D3);

$D3_input=$outputfile."\.t4\.all";
$D3_title="\"D1. SSR loci distribution\"";
$D3_xlabcontent="\"\"";
$D3_addtext="\"T\"";
$figtag="D1.SsrLocifDistr";
$fig_filename=$figout."\.Fig.".$figtag;
$D3=join(' ', "Rscript ssrpie.r",$D3_input,$D3_title,$D3_xlabcontent,$D3_addtext,$fig_filename);
system($D3);

$D3_input=$outputfile."\.t5\.all";
$D3_title="\"E1. SSR length distribution\"";
$D3_xlabcontent="\"\-bp\"";
$D3_addtext="\"T\"";
$figtag="E1.SsrLengthDistr";
$fig_filename=$figout."\.Fig.".$figtag;
$D3=join(' ', "Rscript ssrpie.r",$D3_input,$D3_title,$D3_xlabcontent,$D3_addtext,$fig_filename);
system($D3);  

sub usageinfo()
 {
 my @usage=(); 
 $usage[0]="Usage: To plot statistic graphes for SSR in the investigated whole sequences.\n";
 $usage[1]=" for    help: perl $0 ; \n";
 $usage[2]=" for running: perl $0 -i \{input_file\}.ssr.sat2 [-f1 NO_of_bars_Mer_df10] [-f2 NO_of_bars_motif_df20] [-f3 NO_of_bars_groupedMotif_df20] [-f4 NO_of_bars_frequency_df10] [-f5 NO_of_bars_frequency_df10]\n";
 $usage[3]="e.g.:  perl ssrfig.pl -i testseq.fasta.ssr.sat2\n";
 $usage[4]="Author: Xuewen Wang\n";
 $usage[5]="year 2009, 2013 May,2014 April\n";
 unless(@ARGV){print @usage; exit;} 
 }
unlink glob $outputfile.".t\?";
unlink glob $outputfile.".t4\?";
unlink glob $outputfile."\.t\?"."\.all";
unlink glob $outputfile."\.t\?"."\.full";
exit 0;
