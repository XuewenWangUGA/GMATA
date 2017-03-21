#!/usr/bin/perl -w
use strict;

# script was written by Xuewen Wang, originally designed for parsing SSR output from gssr.pl via
#        removing repeated loci information 
#         and merge loci in overlap region 

# this version run very fast and less memory is required. no bug was found.
#Usage: $0 -i [motif information] -o [trimmed motif searching results] 
# print "Software $0 written by Xuewen Wang from 2012 Jan.  
#current version: 2012 Dec
# The function is to post parsing SSR loci information
#run e.g. :
#perl gssrtrim.pl -i data\testseq.fasta.ssrtemp -o data\testseq.fasta.ssr

&usageinfo();
my %commandin = @ARGV;
if ((scalar @ARGV)%2 != 0){print "arguments must be in pair";}
my $refin=$commandin{"-i"}; #information of input sequence file
my $outfiledefault=$refin.".ssr"; # default output file name if no output file name is given
my $outputfile=$commandin{"-o"}||$outfiledefault; #information of input sequence file
 unless(-e $refin){print "input file does not exist in the working directoty, or the path is not given\n";}
 open (DNAhand, "<$refin")|| die (" $0 filed open failed, pleasse check $refin");
 open(OUT, ">$outputfile")|| die (" $0 Write file failed, pleasse check");
 print OUT "Name\tSeq_Len\tStartPos\tEndPos\tRepetitions\tMotif\n"; #prepare head
 my $myvaluein="";
 my $mykeyid="";
 my %allseqinformation=();
 my %allseqinfor=();
 my %allinfo_farend=();
 my $mykeyid_3='';

while ( <DNAhand>){	# one line at at time
	 chomp ;
	 if ($_=~/^>.*/){
			(my $Name,my $Seq_chunk,my $StartPos,my $EndPos,my $Repetitions,my $tMotif,my $Seq_len)=split("\t",);
			 $myvaluein = join("\t", $Name,$Seq_len,$StartPos,$EndPos,$Repetitions,$tMotif);
			 $mykeyid = join("\$\$", $Name,$StartPos);
			 
			 if(! exists $allseqinformation{$mykeyid}){
				  $allseqinformation{$mykeyid}=$EndPos; 
			 }elsif($allseqinformation{$mykeyid}<$EndPos){ 
			      $allseqinformation{$mykeyid}=$EndPos;
			 }
				$mykeyid_3=$mykeyid.$EndPos;
                 if(! exists $allseqinfor{$mykeyid_3}){
				     $allseqinfor{$mykeyid_3}=$myvaluein; 
				 }
	 } #end if
	 
	 
} #ending while readin
my $fendct=1; 
     foreach my $keyout(sort keys %allseqinformation){
		 my $satis_farend=$keyout.$allseqinformation{$keyout};
			$allinfo_farend{$fendct}=$allseqinfor{$satis_farend};
			$fendct ++;
     }
	 %allseqinformation=(); %allseqinfor=();
close DNAhand;

	$mykeyid_3="";
foreach my $keyL(keys %allinfo_farend){
			(my $Name,my $Seq_len,my $StartPos,my $EndPos,my $Repetitions,my $tMotif)=split("\t",$allinfo_farend{$keyL});
			 $myvaluein = $allinfo_farend{$keyL};
			 $mykeyid = join("\$\$", $Name,$EndPos);			 
			 
			 if(! exists $allseqinformation{$mykeyid}){
				  $allseqinformation{$mykeyid}=$StartPos; 
			 }elsif($allseqinformation{$mykeyid}>$StartPos){ 
			      $allseqinformation{$mykeyid}=$StartPos;
			 }	
				$mykeyid_3=$mykeyid.$StartPos;
                 if(! exists $allseqinfor{$mykeyid_3}){ #if not usful
				     $allseqinfor{$mykeyid_3}=$myvaluein; 
				 }	 
} #ending foreach

		my @AOA=();
     foreach my $keyout(sort keys %allseqinformation){
		 my $satis_farstart=$keyout.$allseqinformation{$keyout};
			my @row= split ('\t', $allseqinfor{$satis_farstart});
			push (@AOA, \@row);
     }
	 %allseqinformation=(); %allseqinfor=();
	 
	 @AOA = sort { 
                $a->[0] cmp $b->[0] ||
                $a->[2] <=> $b->[2] ||
                $a->[3] <=> $b->[3]
            } @AOA;
	foreach my $leve1 (@AOA){
		my $outct=0;
		foreach my $leve2 (@{$leve1}){
			print OUT "\t" if($outct>0);
			print OUT $leve2; 
			$outct++;
		}
		print OUT "\n";
	}
	
close OUT;
unlink $refin;

sub usageinfo
	{# print program name and usage for help if no input aguments available in command line
	my @usage=(); # showing content on how to use the programme
	$usage[0]="Usage: post parsing SSR loci file output from gssr.pl\n";
	$usage[1]=" for    help: perl $0 \n";
	$usage[2]=" for running: perl $0 -i [ssr output file for gssr.pl] -o [final SSR file name]  \n";
	$usage[3]=" e.g. perl gssr.pl -i data\testseq.fasta.ssrtemp -o data\testseq.fasta.ssr\n";
	$usage[4]="Author: Xuewen Wang\n";
	$usage[5]="year 2012,2013 Nov\n";
	unless(@ARGV){print @usage; exit;} 
 }


exit 0;# exit whole program
