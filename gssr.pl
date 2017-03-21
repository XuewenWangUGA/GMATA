#!/usr/bin/perl -w
use strict;
&usageinfo();
my %commandin = @ARGV;
if ((scalar @ARGV)%2 != 0){print "arguments must be in pair\n";}
my $refin=$commandin{"-i"}; #information of input sequence file
my $outfiledefault=$refin.".ssr"; # default output file name if no output file name is given
my $outputfile=$commandin{"-o"}||$outfiledefault; #information of output sequence file
my $motif_min=$commandin{"-m"}||2;# minimum length of any repeat unit, default value is 2
my $motif_max=$commandin{"-x"}||10; # maximum length of any repeat unit,, default value is 10
my $motif_times_min=$commandin{"-r"}||5; # minimum repeated times of a repeat unit, default value is 5
my $seqhight=$commandin{"-s"}||0; #highlight all the repeated sequence consisting of motif in each source sequence
 unless(-e $refin){print "input file does not exist in the working directoty, or the path is not given\n";}
 open (DNAhand, "<$refin")|| die (" $0 filed open failed, pleasse check\n");
 open(OUT, ">$outputfile")|| die (" $0 Write file failed, pleasse check\n");
 my $runlog=$0."\.log";
 open (OUTstat,">>$runlog")|| die (" LOG file writing failed, please check\n");
 print OUT "Name\tSeq_Len\tStartPos\tEndPos\tRepetitions\tMotif\n"; #prepare head
 my $seqID="";
 my $lengthseq=0;
 my $Sequences="";
 my $Sequences_sub="";
 my $positionm=0;
 my $motiflen=0;
 my $readincount=0;
 my $newID="";
 my $oldID="";
 my $leftm=0;
 my $rightm=0;
 my @SSRloci="";
 my $SSRinfo="";
 my $totallength=0;
 $motif_times_min=$motif_times_min-1; 
while ( $Sequences=<DNAhand>){
	chomp $Sequences;
		if($Sequences=~m/^>.+/){ 		    
			$seqID=$Sequences;
            $positionm=0;
            $Sequences_sub="";
			$Sequences="";
            $leftm=0;
            $rightm=0;
            $readincount=0;
	         foreach $SSRinfo(@SSRloci){
			   (print OUT $SSRinfo, "\t",$totallength,"\n" )if(length $SSRinfo != 0);
	         }
			 @SSRloci="";	#reset
			 $totallength=0;			
		}else{
			$Sequences=~ s/[0-9\n\s]//g;						
			$totallength +=length $Sequences;
			$Sequences=$Sequences_sub.$Sequences;
			$readincount =$readincount+1;
			$lengthseq=length $Sequences;
	while($Sequences=~ /([ACGT]{$motif_min,$motif_max}?)\1{$motif_times_min,}/gix){  
		my $motif=uc $1;
        $motiflen=length $motif;		
		my $removelen=int($motiflen/2)+1 ;
		$removelen =1 if ($removelen <=1);
		$leftm=$-[0]+1; 
		$rightm= $+[0]; 
		unless ($motif=~/^([ACGT]{1,$removelen})\1+$/ix){#motif while 
			my $repeat_times=($rightm-$leftm+1)/$motiflen;
			$leftm=$leftm+$positionm;
			$rightm=$rightm+$positionm;
			 push (@SSRloci,join("\t",$seqID,$readincount, $leftm,$rightm,$repeat_times,$motif));
			if ($seqhight == 1){
				print OUT lc $` ; # print seq before left position, start position
				print OUT uc $& ; #"Microsatellites: ",
				print OUT lc $',"\n" ; #print sequence after right position
			} #end if			
		 } #ending unless 
	    } #ending while for getting motif 
		 my $reconsiderlen=20;
         $positionm = $positionm + $lengthseq - $reconsiderlen + 1;
        $Sequences_sub = substr($Sequences, $lengthseq - $reconsiderlen + 1, $reconsiderlen - 1);
	} # end  else to do while search:	looking for motif	
	if (eof(DNAhand)){ #print data for last seqID
			         foreach $SSRinfo(@SSRloci){
						(print OUT $SSRinfo, "\t" )if(length $SSRinfo != 0);
						 (print OUT $totallength, "\n")if(length $SSRinfo != 0);
					}
    }
} #ending while readin
&runtime(\*OUTstat); #for run log information
close DNAhand;
close OUT;
close OUTstat; 
sub usageinfo
	{# print program name and usage for help if no input aguments available in command line
	my @usage=(); # showing content on how to use the programme \n";
	$usage[1]=" for    help: perl $0 ; \n";
	$usage[2]=" for running: perl $0 -i [formated sequence file] -o [motif searching results] 
	-r [minimum repeated times] -m [minimum motif length] -x [maximum motif length] 
	-s [highlight motif in sequence 0 or 1] \n";
	$usage[3]="Author: Xuewen Wang\n";
	$usage[4]="year 2012\n";
	unless(@ARGV){print @usage; exit;} 
 }
sub runtime(){
	my $OUTfile=shift @_;
	my $local_time = gmtime();
	print {$OUTfile} "$0 was run and results were yielded at $local_time\n";
}
exit;# exit whole programme
