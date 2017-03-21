#!/usr/bin/perl -w
use strict;
&usageinfo();
# usage: perl fragct.pl  -i markerAmplicon_resultfrom_eparsing  -o MarkerAmpliconCount.frg
# Note: copy right is owned by Xuewen Wang, original designed for statistical of .amp data from ePCR";
my %commandin = @ARGV;
if ((scalar @ARGV)%2 != 0){print "arguments must be in pair";}
my $dbfile=$commandin{"-i"}; #input file from direct ePCR results
my $outputfile=$commandin{"-o"}; # # statistic file for parsed ePCR fragments
	unless(-e $dbfile){print "database fasta file does not exist in the working directoty\n";}
	open(OUT, ">$outputfile")|| die (" Write file failed, pleasse check");
	open (DNAhand,$dbfile)|| die (" filed open failed, pleasse check"); # basic file
	open (OUTstat, ">$outputfile.sat4")|| die (" Write file failed, pleasse check");
	print "Statistics of size-based allelles of each marker after ePCR and eMapping.\n";
	print "parameters: -.\n";
	print "output files: \n Marker and its number of amplicons:\n $outputfile\n";
	print " Statistical data of ePCR and eMapping: \n $outputfile.sat4\n";
	print formatedrealtime(); 
my $key_ct=0;
my %allseqinformation= ();
my %markalleles=();#alleles
my %seqID=();
my $seqID_ct=0;
my $previouslength="";
my $newlength="";
my @unitlen=();
my $amplicon_ct=0; #total amplicons
my $mkkey_ct=0; #total markers
while (my $DNAseries=<DNAhand>){
	chomp $DNAseries;
  my @readpart = split('\t', $DNAseries);
  my $sword2=$readpart[0]; #marker
  my $length2=$readpart[5]; #length/designed length, alleles
  my $sword3=$readpart[1]; #seqID
    my $newlength=$length2;	
			if(! exists $allseqinformation{$sword2}){
				$allseqinformation{$sword2} =1; 
				$previouslength=$newlength; # new marker ID
			}elsif($previouslength ne $newlength){	
				$allseqinformation{$sword2} ++;
			}#endif
			if(! exists $markalleles{$sword2}){
				$markalleles{$sword2} =$newlength; 
				$previouslength=$newlength; # new marker ID
			}elsif($markalleles{$sword2} !~ m/$newlength/){	
				$markalleles{$sword2} =$markalleles{$sword2}."\,".$newlength;
			}#endif			
			if(! exists $seqID{$sword3}){
				$seqID{$sword3}=1; 
				$seqID_ct ++; # new marker ID
			}#endif	
  } #end while
	&sort_key(\%allseqinformation); 
	&runtime(\*OUTstat);# for running log	
		my $freqref_unitlen = &fre_ct_batch(\@unitlen); 
		#count  occurrence of amplicons number/alleles
		print OUTstat "Table 1 Summary of ePCR\n";
		print OUTstat "Alleles\tTotal_markers\tPercentage\n";# head line		
		&val_ascend($freqref_unitlen,\*OUTstat); #sort and print
		print OUTstat "\n";
		print OUTstat "Table 2 Summary of eMapping\n";
		print OUTstat "Total NO. of sequences with markers mapped to:\t$seqID_ct\n";
		print OUTstat "Total markers mapped to input sequences:\t$mkkey_ct\n";
		print OUTstat "Total amplicons PCRed from mapped markers:\t$amplicon_ct\n";
		my $average_ampliconPerMk=$amplicon_ct/$mkkey_ct;
		print OUTstat "Average amplicons per mapped marker:\t$average_ampliconPerMk\n";
		print OUTstat "\n";
close DNAhand;
close OUTstat;
sub sort_key(){
my %hash_in=%{shift @_};
	foreach  my $key(sort {$a cmp $b} keys %hash_in){ #sort by marker ID	
			print OUT $key ,"\t", $hash_in{$key},"\t", $markalleles{$key},"\n"; # print marker(key), frequency in ascend order
			$amplicon_ct=$amplicon_ct+$hash_in{$key};
			$mkkey_ct =$mkkey_ct+1; #count the total occurrence of key (marker)
			push (@unitlen, $hash_in{$key}); # get amplicons number/alleles of each marker: , e.g. 2, ok
	}#end foreach
}
sub val_ascend(){ #sort
		my ($fref,$outfile)=@_;
		my %refhash=%{$fref};
		my $value_total=0;
		my $key_ct=0;
		my $totalpercentage=0;
		my $percentage=0;				
		foreach  my $key(sort {$refhash{$b} <=> $refhash{$a}} keys %refhash){
		    $percentage=$refhash{$key}/$mkkey_ct*100; #$amplicon_ct global
			print {$outfile} $key ,"\t", $refhash{$key}, "\t",$percentage,"\n"; #updated on Jan 22 2013
			$value_total =$refhash{$key}+$value_total;#count the sum
			$key_ct =$key_ct+1; #count the total occurrence of key
			$totalpercentage=$percentage+$totalpercentage;
		}
		print {$outfile} "total_above\ttotal_above\ttotal_above\n";
		print {$outfile} $key_ct, "\t",$value_total,"\t",$totalpercentage,"\n";	
	} #end sub
	sub fre_ct_batch(){ 
		my @cells=@{shift @_}; #ok
		my %allseqinformation= ();
		my $sword="";
		foreach $sword (@cells){
			if(! exists $allseqinformation{$sword}){$allseqinformation{$sword}=1;}
			else{$allseqinformation{$sword}++;}
		} #end each
		return \%allseqinformation;
	} # end sub
sub usageinfo(){# print program name and usage for help if no input arguments available in command line
 my @usage=(); # showing content on how to use the programme
 $usage[0]="Usage: original designed for statistical of .amp data from ePCR.\n";
 $usage[1]=" for    help: perl $0 ; \n";
 $usage[2]=" for running: perl $0 -i markerAmplicon_resultfrom_eparsing.amp -o MarkerAmpliconCount.frag\n";
 $usage[3]="Author: Xuewen Wang\n";
 $usage[4]="year 2009, 2013 Nov,2014 April\n";
 unless(@ARGV){print @usage; exit;} 
 }
sub formatedrealtime {
my @weekday = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");
my $local_time = gmtime();
my $runtime= "results yielded at $local_time\n\n";
return $runtime;
}
	sub runtime() {
		my $OUTfile=shift @_;
		my $local_time = gmtime();
		print {$OUTfile} "$0 was run and results were yielded at $local_time\n";
	} # end sub

exit;
