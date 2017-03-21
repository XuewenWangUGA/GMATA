#!/usr/bin/perl -w
use strict;
&usageinfo();
	my %commandin = @ARGV;
	if ((scalar @ARGV)%2 != 0){print "arguments must be in pair";}
	my $refin=$commandin{"-i"}; #information of input file
	my $outputfile=$refin.".gbf";
	open (DNAhand,$refin)|| die (" $0 file opening failed, please check");
	open (OUT,">$outputfile")|| die (" $0 file writing failed, please check"); # gff3 data file name
print "Producing Growse gff file (.gbf). \n Output files: \n $outputfile \n";
	my $word="";
	my @cellinfor="";
my $type="SSR";
print OUT "\[$type\]\n";
print OUT "glyph = segments\n";
print OUT "bgcolor = green\n";
print OUT "key = $type or Microsatellite\n";
print OUT "bump=1\n";
print OUT "label=1\n";
print OUT "description = 1\n";
print OUT "\n";
my $locusct=1;
	while ($word=<DNAhand>){ 	
		chomp $word;		
		my @cellinfor=split("\t",$word);
		unless ($word =~/Name	Seq_Len	StartPos	EndPos	Repetitions	Motif/){
			$cellinfor[0]=~ s/\>//;
			print OUT $type,"\t"; #collumn 1
			print OUT "SSR",$locusct,"\t"; #collumn 2
			print OUT $cellinfor[0], "\:", $cellinfor[2], "\.\.", $cellinfor[3], "\t"; #collumn 3
			my $description=$cellinfor[4]."\:".$cellinfor[5]."\@".$cellinfor[0]."\:".$cellinfor[2]."\.\.".$cellinfor[3];
			print OUT "Note=",$description,"\n";  #collumn 4 description
			$locusct++;
		}	
    } #end while
sub usageinfo{
		my @usage=(); # showing content on how to use the programme
		$usage[0]="Usage: generate Gbrowse Feature File based on ssr loci file\n";
		$usage[1]=" for    help: perl $0 ; \n";
		$usage[2]=" for running: perl $0 -i [ssr loci file] \n";
		$usage[3]="e.g.:  perl ssr2gff.pl -i testseq.fasta.ssr\n";
		$usage[4]="Author: Xuewen Wang\n";
		$usage[5]="year 2013. May\n";
		unless(@ARGV){print @usage; exit;} 
 } #end sub
exit;
