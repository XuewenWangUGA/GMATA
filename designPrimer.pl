#!/usr/bin/perl -w
#usage: perl designPrimer.pl -i inputfile -p w:Win_u:Unix_default:w -smin  ampliconMinSize -Smax  ampliconMaxSize -tm optionalAnnealling_tm_def:60 -o resultfileName -dir pathofPrimer3_forunix
# Note: copy right is owned by Xuewen Wang, original designed for designing primers for SSR loci in unix and Windows";
#print "Copy right protected. All rights reserved. Versions 2009 Oct, 2010 Mar,2012 May, 2013 May and scripts programmed by Xuewen Wang.\n";
if ((scalar @ARGV)== 0){print  usageinfo(); exit;}
my %commandin = @ARGV;
 if ((scalar @ARGV)%2 != 0){print "arguments must in pair";}
 my $outfile=$commandin{"-o"};
 my $size_min=$commandin{"-smin"}||100; 
 my $size_max=$commandin{"-Smax"}||400; 
 my $file=$commandin{"-i"};
 my $systemplatform=$commandin{"-p"}||"w"; #single letter: w or u w-forWin_u-forUnix, default w
 my $primer_temp=$outfile."\.temp";
 my $primer_out=$outfile;
 my $anneal_tm=$commandin{"-tm"}||60.0;
 my $defaultdir='/primer3-2.2.3/src'; #/primer3-2.2.3/src
 my $directorPrimcore=$commandin{"-dir"}||$defaultdir;
print "Preparing data and designing primers.\n";
print "parameters: -p $systemplatform -smin $size_min -Smax $size_max -tm $anneal_tm\n";
print formatedrealtime();

open (DNAhand,$file)|| die (" file open failed, pleasse check");
open (OUT,">$primer_temp")|| die (" result file writing failed, pleasse check");

while ($DNA = <DNAhand>){
chomp $DNA;
@DNAseries = split ('\t',$DNA);

$seqID=shift @DNAseries;
$seq=shift @DNAseries;
$regstart = shift @DNAseries;
$reglength = shift @DNAseries;
$sizeRange=$size_min."-".$size_max;
print OUT "PRIMER_SEQUENCE_ID=",$seqID,"\n";
print OUT "SEQUENCE=",$seq,"\n";
print OUT "PRIMER_MAX_NS_ACCEPTED=1\n";
print OUT "PRIMER_PRODUCT_SIZE_RANGE=$sizeRange\n";
print OUT "PRIMER_OPT_SIZE=20\n";
print OUT "PRIMER_MIN_SIZE=18\n";
print OUT "PRIMER_MAX_SIZE=25\n";
print OUT "PRIMER_OPT_TM=$anneal_tm\n";
print OUT "PRIMER_MIN_TM=57.0\n";
print OUT "PRIMER_MAX_TM=62.0\n";
print OUT "PRIMER_MIN_GC=40.0\n";
print OUT "PRIMER_MAX_GC=65.0\n";
print OUT "PRIMER_OPT_GC_PERCENT=50.0\n";   
print OUT "TARGET=$regstart,$reglength\n";
print OUT "PRIMER_MAX_END_STABILITY=9.0\n";
print OUT "PRIMER_MAX_POLY_X=4\n";
print OUT "PRIMER_SELF_ANY=6.00\n";
print OUT "PRIMER_SELF_END=2.00\n";
print OUT "PRIMER_GC_CLAMP=0\n";
print OUT "PRIMER_LIBERAL_BASE=1\n";
print OUT "PRIMER_NUM_RETURN=1\n";     
print OUT "=\n";
}
close DNAhand;
close OUT;
#primer3-2.2.3/src
my $go='';
if ($systemplatform eq "w"){
	system("primer3_core.exe <$primer_temp >$primer_out");
}elsif($systemplatform eq "u"){
	my $dirpos=$directorPrimcore;
		if($dirpos eq $defaultdir){#default
			$go='primer3_core';
		}else{
			$go=$dirpos.'/'.'primer3_core';
		}
	system("$go -io_version=3 <$primer_temp >$primer_out");
}


 unlink $primer_temp;
exit;
 sub usageinfo
 {
 my @usage=(); 
 $usage[0]="Usage: \n";
 $usage[1]=" for    help: perl $0 ; \n";  
 $usage[2]=" for running: perl $0 -i input_seqfile -p w:Win_u:Unix_default:u -smin  ampliconMinSize -Smax  ampliconMaxSize -tm optionalAnnealling_tm_def:60 -o resultfileName -dir PathofPrimer3_forUnix\n\n";
 $usage[3]="Author: Xuewen Wang\n";
 $usage[4]="year 2009-2013, Nov\n\n";
 return @usage; 
 }
sub formatedrealtime {
my @weekday = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");
my $local_time = gmtime();
my $runtime= "results yielded at $local_time\n\n";
return $runtime;
}
