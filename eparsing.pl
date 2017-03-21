#!/usr/bin/perl -w
use strict;
&usageinfo();
my %commandin = @ARGV;
if ((scalar @ARGV)%2 != 0){print "arguments must be in pair";}
my $dbfile=$commandin{"-i"}; #input file
my $outputfile=$commandin{"-o"}; # output file
&sub_sort($dbfile,$outputfile);
sub sub_sort(){ 
	(my $dbfile, my $outputfile)=@_;
	unless(-e $dbfile){print "database fasta file does not exist in the working directoty\n";}
	open(OUT, ">$outputfile")|| die (" Write file failed, pleasse check");
	open (DNAhand,$dbfile)|| die (" filed open failed, pleasse check"); # ePCR data information file
	my %mklengthhash;
	while (my $DNAseries=<DNAhand>){
		chomp $DNAseries;
		my @readpart = split('\t', $DNAseries);
		my $sword=$readpart[1]; #marker
		my $length=$readpart[5]; #length
		my $realcorrectlen=abs($readpart[4]-$readpart[3]+1);
		my @errorscell=split('\/',$length);
		my $secondhalf=$errorscell[1];
		$length=$realcorrectlen.'/'.$secondhalf;
		$readpart[5]=$length;
		$DNAseries=join("\t",@readpart);
		my $mk_length=$sword."\-".$length; # combined value as unique key in hash
		($mklengthhash{$mk_length}=$DNAseries) if ($sword=~/\>/); # store ePCR results, fixing ePCR error output
	} #end while
	&sort_key_cells(\%mklengthhash, \*OUT); 
close DNAhand;
close OUT;
} #end sub_sort
sub sort_key_cells(){
	my %hash_in=%{shift @_};
	my $outfile=shift @_;
	my $key_ct=0;
	foreach  my $key(sort  keys %hash_in){ #sort by marker ID
			my @cells=split ('\t', $hash_in{$key});
			$cells[5]=~ s/\-\d+$//;
			print {$outfile} join("\t", $cells[1],$cells[0],@cells[2..4],$cells[5],@cells[6..7]), "\n";
			$key_ct =$key_ct+1; 
    } 
}
	
sub usageinfo(){
 my @usage=(); 
 $usage[0]="Usage: information in additional file will be added to last collumn of each line in 1st file (basic file) if comtent in first cell of each line in each file is same.\n";
 $usage[1]=" for    help: perl $0 ; \n";
 $usage[2]=" for running: perl $0 -i [ePCR_out_file.YourTag]  -o [ePCR_out_file.YourTag.amp] \n";
 $usage[3]="Author: Xuewen Wang\n";
 $usage[4]="year 2009, 2013, Nov\n";
 unless(@ARGV){print @usage; exit;} 
 }
exit;
