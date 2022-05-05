#!/usr/bin/perl -w
use strict;
&usageinfo();
my %commandin = @ARGV;

if ((scalar @ARGV)%2 != 0){print "arguments must be in pair\n";}
my $refin=$commandin{"-i"}; #information of input sequence file
my $ssrf=$commandin{"-r"}||$refin.".ssr"; #SSR file name
my $seqhight=$commandin{"-s"}||0; 
 my $refinfms=$refin.".fms";
 my $outputfile=$refin.".ssrMasked.fasta";

 unless(-e $refin){print "input file does not exist in the working directoty, or the path is not given\n";}

 open (DNAhand, "<$refinfms")|| die (" $0 file $refinfms open failed, pleasse check\n");
 open(OUT, ">$outputfile")|| die (" $0 Write file $outputfile failed, pleasse check\n");
 my $runlog=$0."\.log";
 open (OUTstat,">>$runlog")|| die (" LOG file $runlog writing failed, please check\n");
 
 ##read in the SSRs position information
 open (DNApos, "<$ssrf")|| die (" $0 file $ssrf open failed, pleasse check\n");
print OUTstat "Maksing the SSR: parameters setting are: -s $seqhight -i $refin -r $ssrf\n";
print "\nMaksing the SSR...\nparameters setting are: -s $seqhight -i $refin -r $ssrf\n";
print "Please wait during masking ...\n"; 
my @ssrcells=();
my %ssrhash=();
my $lineno=1;
my $ssrcells_ID="x";
my $ssrcells_len=0;
my $ssrcells_str=0;
my $ssrcells_end=0;
my $pospair="";
while(my $ssrpos=<DNApos>){
		chomp $ssrpos;
		if($lineno>1){
			@ssrcells=split("\t", $ssrpos);
			$ssrcells_ID=$ssrcells[0];
			$ssrcells_len=$ssrcells[1];
			#print "ssr_len:  ",$ssrcells_len,"\n";
			$ssrcells_str=$ssrcells[2];
			$ssrcells_end=$ssrcells[3];
			$pospair=join("_", $ssrcells_str,$ssrcells_end);
			if (!exists $ssrhash{$ssrcells_ID}){
					$ssrhash{$ssrcells_ID}=join ("\t",$ssrcells_len, $pospair);
			}else{
					$ssrhash{$ssrcells_ID}=join ("\t", $ssrhash{$ssrcells_ID},$pospair);
				
			}
					
		}
		$lineno ++;
		

}


local $/ = "\n>";  # read by FASTA tag >
my $seqinfo="";
while ( $seqinfo=<DNAhand>){
	chomp $seqinfo;
	$seqinfo =~ s/^>*(.+)\n//;	
     my $seqID=">".$1; #   head line
     $seqinfo=~ s/\n//g;
	 my $eachseqlen=length $seqinfo;
	 
	 if (exists $ssrhash{$seqID}){
		my @poscells=split ("\t", $ssrhash{$seqID});
		my $ssrseqlen=shift @poscells;
		if($eachseqlen==$ssrseqlen){
			my $startposition=0;
			my $endpos=0;
			my $ssrct=1;
			my $extrlength=0;
			foreach my $pos(@poscells){
				($startposition,$endpos)=split ('_', $pos);
				$startposition --;
				$endpos --;
				$extrlength=$endpos-$startposition+1;		
				my $mask= "";
				my $maskchar="N";
				for (my $in =1;$in <= $extrlength; $in ++ ){
					$mask=join("",$mask,$maskchar);
				}
				if ($seqhight==1){
					my $ssrseq=substr($seqinfo,$startposition,$extrlength, $mask);
					substr($seqinfo,$startposition,$extrlength, lc $ssrseq)
				}elsif($seqhight==2){
					substr($seqinfo,$startposition,$extrlength, $mask);
				}	
			}		
			print OUT $seqID, "\n","$seqinfo\n";
		}
		
	 }else{
			print OUT $seqID, "\n", $seqinfo,"\n";
				
		}
} #ending while readin
print "Result file: $outputfile\n";
close DNAhand;
close OUT;
close DNApos;
&runtime(\*OUTstat); #for run log information
close OUTstat; 

sub usageinfo
	{# print program name and usage for help if no input aguments available in command line
	my @usage=(); # showing content on how to use the programme \n";
	$usage[1]=" for    help: perl $0 ; \n";
	$usage[2]=" for running: perl $0 -i [sequence fasta file] -s [1 for low case SSR or 2 for mask SSR in N]-r [SSR loci file];
	out result file : same file name with suffix .masked.fasta\n";
	$usage[3]="Author: Xuewen Wang\n";
	$usage[4]="year 2018\n";
	unless(@ARGV){print @usage; exit;} 
 }
 
sub runtime(){
	my $OUTfile=shift @_;
	my $local_time = gmtime();
	print {$OUTfile} "$0 was run and results were yielded at $local_time\n";
	print  "results were yielded at $local_time\n\n";
}
exit;# exit whole programme
