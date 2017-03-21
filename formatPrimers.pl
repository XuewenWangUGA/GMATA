#!/usr/bin/perl -w
use strict;
#use library;
#usage: perl formatPrimers.pl -ts T/F_OutputTemplateSeq -i Primer3outfile -o finalPrimer.txt
#print "Copy right protected. All rights reserved. Versions 2010 Mar, 2013 May and scripts programmed by Xuewen Wang.\n";
if ((scalar @ARGV)== 0){print  usageinfo(); exit;}
my %commandin = @ARGV;
 if ((scalar @ARGV)%2 != 0){print "arguments must in pair\n";}
 my $outfile=$commandin{"-o"};
 my $file=$commandin{"-i"};
 my $templateSeq=$commandin{"-ts"}||"F"; 
 my $markerprefix= $commandin{"-n"}||"MK"; #name prefix of marker
 print "Processing primer and producing final primers.\n";
 print "parameters: -ts $templateSeq \n Output files: \n$outfile \n$outfile.sts \n$outfile.sat3\n";
 print formatedrealtime();
 open (DNAhand,$file)|| die (" file open failed, pleasse check\n");
 open (OUT,">$outfile")|| die (" result file writing failed, pleasse check\n");
 open (STS, ">$outfile.sts")|| die (" result file writing failed, pleasse check\n"); # information for Primers pairs
 open (SAT, ">$outfile.sat3")|| die (" result file writing failed, pleasse check\n"); # statistic of primer designing, Marker information
print OUT "SequenceID \t", "MarkerID\t","PRIMER_LEFT_SEQUENCE \t", "PRIMER_LEFT_TM \t", "PRIMER_RIGHT_SEQUENCE \t", "PRIMER_RIGHT_TM \t", "LEFT_PRIMER_POS \t","RIGHT_PRIMER_POS \t","PRODUCT_SIZE ";
if ($templateSeq eq "T"){
	print OUT "\t","Flanking_Sequence \n";}
else{
	print OUT "\n";
}
 $/= "PRIMER_SEQUENCE_ID=>";
 my $i=0;
 my $ii_primer=0;
 my %allseqinformation= (0,0); # to be global
 my $tempv=0;
 my $markerID="";
 my $mkcounter=0;
 my $mktota=0;
 my $Sequences="";
 my $lprimer="";
 my $rprimer="";
 my $mktotal=0;
 my $productsize="";
 
while (my $DNAseries=<DNAhand>){
 my $ltm="";
 my $rtm="";
 my $leftprimerpos=""; 
 my $rightprimerpos="";
 $lprimer="";
 $rprimer="";
 $productsize=""; 

  my @readpart = split('\n', $DNAseries);
  my $readparthheader=shift @readpart;
  $readparthheader=~ s/\s//;
  pop @readpart;
 foreach my $itemfromprimer3(@readpart) {
    $Sequences = $readpart[0];
   $Sequences =~ s/SEQUENCE=//;
   if ($itemfromprimer3=~ "PRIMER_LEFT_SEQUENCE="){$lprimer = $itemfromprimer3; $lprimer=~ s/PRIMER_LEFT_SEQUENCE=//; }
   if ($itemfromprimer3=~ "PRIMER_LEFT_TM="){$ltm = $itemfromprimer3; $ltm=~ s/PRIMER_LEFT_TM=//;}
   if ($itemfromprimer3=~ "PRIMER_RIGHT_SEQUENCE="){$rprimer = $itemfromprimer3; $rprimer=~ s/PRIMER_RIGHT_SEQUENCE=//; }
   if ($itemfromprimer3=~ "PRIMER_RIGHT_TM="){$rtm = $itemfromprimer3; $rtm=~ s/PRIMER_RIGHT_TM=//;}
   if ($itemfromprimer3=~ "PRIMER_PRODUCT_SIZE="){$productsize = $itemfromprimer3; $productsize=~ s/PRIMER_PRODUCT_SIZE=//;}
   if ($itemfromprimer3=~ "PRIMER_LEFT="){my $leftprimer = $itemfromprimer3; $leftprimer=~ s/PRIMER_LEFT=//; my @leftprimerposlen=split(",",$leftprimer);$leftprimerpos=$leftprimerposlen[0]; }
   if ($itemfromprimer3=~ "PRIMER_RIGHT="){my $rightprimer = $itemfromprimer3; $rightprimer=~ s/PRIMER_RIGHT=//; my @rightprimerposlen=split(",",$rightprimer);$rightprimerpos=$rightprimerposlen[0]; }  
 } #end foreach
 my $primerLR_seq=$lprimer.$rprimer;
 if ((length $primerLR_seq) >= 10){ # calculate markerID for none empty primer pair
	($markerID, $mktotal)=&fre_ct_ID(\$primerLR_seq); 
 }else{
	$markerID=""; # ignore markerID for empty primer pair
 }
if ($i>=1){
  print OUT ">", $readparthheader,"\t";
  print OUT $markerID,"\t";
  print OUT $lprimer, "\t", $ltm, "\t";
  if(length $lprimer==0){ $ii_primer += 1;}
  print OUT $rprimer, "\t", $rtm, "\t";
  print OUT $leftprimerpos, "\t",$rightprimerpos, "\t";
  print OUT $productsize, "\t";
 (print  OUT $Sequences) if ($templateSeq eq "T");
  print OUT "\n";
}#end if
$i += 1;
}
close DNAhand;
close OUT;
close STS;
my $withprimperc=($i-1-$ii_primer)/($i-1)*100;
my $noprimperc=($ii_primer)/($i-1)*100;
print SAT "total SSR loci are : ", $i-1,"\n";
print SAT "total ssr loci and percentage with primer pair designed are: ", $i-1-$ii_primer,"\,\t",$withprimperc,"\%","\n";
print SAT "total ssr loci and percentage without primer pair designed are : ", $ii_primer,"\,\t",$noprimperc,"\%","\n";
print SAT "total NO. of unique markers is : ", $mktotal,"\n";
close SAT;
exit;
 sub usageinfo
 {
 my @usage=(); 
 $usage[0]="Usage: to produce final Primers\n";
 $usage[1]=" for    help: perl $0 ; \n";
 $usage[2]=" for running: perl $0 -ts T_or_F_forOutTemplateSeq -i Primer3outfile -o finalPrimerFile\n\n";
 $usage[3]="Author: Xuewen Wang\n";
 $usage[4]="year 2012 May, 2013 May, Nov\n\n";
 return @usage; 
 } 
sub formatedrealtime {
my @weekday = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");
my $local_time = gmtime();
my $runtime= "results yielded at $local_time\n\n";
return $runtime;
}
	sub fre_ct_ID(){ 
		my $sword=${shift @_}; #ok
			if(! exists $allseqinformation{$sword}){
				$allseqinformation{$sword}=$tempv+1; #  presence
				$tempv=$allseqinformation{$sword};
				$mkcounter ++; 
				$markerID="\>$markerprefix".$mkcounter;
				&sts_generator();
			}else{ # if a existed marker appears, should use the existed ID
				$markerID="\>$markerprefix".$allseqinformation{$sword};
			}
		return $markerID, $mkcounter;
	} # end sub	
	sub sts_generator(){
	print STS $markerID,"\t";
	print STS $lprimer, "\t";
	print STS $rprimer, "\t";
	print STS $productsize, "\n";
	}