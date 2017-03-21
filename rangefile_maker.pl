#!/usr/bin/perl -w
use strict;
if ((scalar @ARGV)== 0){print  usageinfo(); exit;}
my %commandin = @ARGV;
 if ((scalar @ARGV)%2 != 0){print "arguments must in pair";}
 my $outfile=$commandin{"-o"};
 my $refseq=$commandin{"-i"};
 my $givingflank=$commandin{"-fl"}||200;
open (RANGE, $refseq)|| die (" !!!!!!!!!!!file open failed, pleasse check!!!!!!!!");
open (OUT, ">$outfile")|| die (" !!!!!!!!!!!file write failed, pleasse check!!!!!!!!");
 print "Preparing loci range information based on SSR information.\n";
 print "parameters: -fl $givingflank, Output file: $outfile.\n";
 print formatedrealtime();
print OUT "seqID\trange_start\trange_end\tfeatureLstart\tfeatureRend\trelat_featureStart\trelat_featureEnd\n"; 
my $i=1; # to remove /control heanline
while (my $series=<RANGE>){
       chomp $series;
	   my $headlinecontent="Name\tSeq_Len\tStartPos\tEndPos\tRepetitions\tMotif";
	   unless ($series =~ $headlinecontent){
		my @seriescell = split('\t', $series);	   
		my $Name=$seriescell[0];
		my $Seq_len=$seriescell[1];
		my $StartPos=$seriescell[2];
		my $EndPos=$seriescell[3];
		my $Lflank=0;
		my $Rflank=20;# 20 is decided by primer length;		
		if ($StartPos>$givingflank){
			$Lflank=$StartPos-$givingflank; 
		}else{$Lflank=1; #  for short, extract from beginning 1
		}
		if ($Seq_len-$EndPos+1 >=$givingflank){$Rflank=$givingflank+$EndPos; #for long seq ,extract started from right 200 nt away
		}else{$Rflank=$Seq_len;} # for short, extract till end
		my $relat_featureStart=$StartPos-$Lflank+1;
		my $relat_featureEnd=$EndPos-$Lflank+1;
	   print OUT "$Name\t", "$Lflank\t","$Rflank\t","$StartPos\t","$EndPos\t","$relat_featureStart\t","$relat_featureEnd\n";
	   }
}    
        close RANGE;
		close OUT;
 sub usageinfo
 {
 my @usage=();
 $usage[0]="Usage: \n";
 $usage[1]=" for    help: perl $0 ; \n";
 $usage[2]=" for running: perl $0 -i input.ssr -fl flank_length_eitherSide -o rangefile.txt\n\n"; 
 $usage[3]="Author: Xuewen Wang\n";
 $usage[4]="year 2012, May, 2013 Nov\n\n";
 return @usage; 
 }
sub formatedrealtime {
my @weekday = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");
my $local_time = gmtime();
my $runtime= "results yielded at $local_time\n\n";
return $runtime;
}
exit;