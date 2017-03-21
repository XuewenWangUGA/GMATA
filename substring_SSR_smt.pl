#!/usr/bin/perl -w
use strict;
my %commandin = @ARGV;
 if ((scalar @ARGV)== 0){print  usageinfo(); exit;}
 if ((scalar @ARGV)%2 != 0){print "arguments must in pair";}
 my $outfile=$commandin{"-o"};
 my $refseq=$commandin{"-s"};
 my $rangefile=$commandin{"-r"};
 my $maxilen=$commandin{"-l"}||2000; #Maxi allowed PCRInput length, default is 2000
 print "Preparing sequence for primer designing.\n";
 print "parameters: -s $refseq, -r $rangefile, -l $maxilen, Output file: $outfile\n";
 print formatedrealtime();
 	open (OUT, ">$outfile"); 
	open (REFDNA, $refseq)|| die (" !!!!!!!!!!!filed open failed, pleasse check!!!!!!!!");
		my $indexedRang_ref=&range_index($rangefile);
		my %indexRangPostn=%{$indexedRang_ref};	
while (my $refseries=<REFDNA>){ 
       (my $refID, my $Sequences) = split('\t', $refseries);
        chomp $refID;
         $Sequences =~ tr/actg/ACTG/;
         $Sequences =~ s/\s//; 
         $Sequences =~ s/[0-9]//g; 
		chomp $Sequences;
		my $seqlen=length $Sequences;	 
		if (exists $indexRangPostn{$refID}){
			my @seriesline=split ('@@',$indexRangPostn{$refID}); 
		foreach my $series(@seriesline){
			(my $seqID, my $range_start, my $range_end, my $featureLstart, my $featureRend, my $relat_featureStart, my $relat_featureEnd)=split('\t', $series);
		    my $startposition=$range_start;
			my $endposition=$range_end;
			my $extrlength=$endposition-$startposition+1;
			print OUT "position error\n" if($extrlength<=0);
			if ($seqlen >= $maxilen){
				print OUT $seqID."\|".$range_start."\:".$range_end."\|".$featureLstart."\:"."$featureRend\t";
				print OUT uc substr($Sequences,$startposition,$extrlength),"\t";
				my $Feature_length=$relat_featureEnd-$relat_featureStart+1;
				print OUT "$relat_featureStart\t", "$Feature_length\n";
			}else{
				print OUT $seqID."\|"."1"."\:".$seqlen."\|".$featureLstart."\:"."$featureRend\t";
				print OUT $Sequences,"\t";
				my $Feature_length= $featureRend-$featureLstart+1;
				print OUT "$featureLstart\t", "$Feature_length\n";			
			}
		}# foreach
        } # end if exists
} #END #1 while
close OUT;
close REFDNA;
 sub usageinfo
 {# print program name and usage for help if no input available in command line
 my @usage=(); # show how to use the programme
 $usage[0]="Usage: \n";
 $usage[1]=" for    help: perl $0 ; \n";
 $usage[2]=" for running: perl $0 -o outresultfile.txt -s inputsequencefile.fa -r range_positionfile.txt -l maxiPCRInputlen_Def2000\n\n";
 $usage[3]="Author: Xuewen Wang\n";
 $usage[4]="year 2010, 2012, 2013\n\n";
 return @usage; 
 } 
sub formatedrealtime {
my @weekday = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");
my $local_time = gmtime();
my $runtime= "results yielded at $local_time\n\n";
return $runtime;
}
sub range_index(){
	my $rangefile=shift @_; #ok,
	open (RANGE, $rangefile)|| die (" !!!!!!!!!!!filed open failed, pleasse check!!!!!!!!");
	my %rangehash=();
	
	while (my $series=<RANGE>){	
		chomp $series;
		unless($series=~ /range_start/){ 
			my @rangcells=split('\t', $series);
			my $seqID=shift @rangcells;
			if(!exists $rangehash{$seqID}){
				$rangehash{$seqID}=$series;
			}else{
				my $positions=$rangehash{$seqID}.'@@'.$series; #add posotion data to index
				$rangehash{$seqID}=$positions;
			} 		
		} # end unless
	} # end while
	close RANGE;
	return \%rangehash; #return reference of indexed range information
} # end sub
exit;