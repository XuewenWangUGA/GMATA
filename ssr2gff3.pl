#!/usr/bin/perl -w
use strict;
#version v2.1
&usageinfo();
	my %commandin = @ARGV;
	if ((scalar @ARGV)%2 != 0){print "arguments must be in pair";}
	my $refin=$commandin{"-i"}; #information of input file
	my $outputfile=$refin.".gff3";
	open (DNAhand,$refin)|| die (" $0 file opening failed, please check");
	open (OUT,">$outputfile")|| die (" $0 file writing failed, please check"); # gff3 data file name
print "Producing Gbrowse gff3 file (.gff3). \n Output files: \n $outputfile\n";
	my $word="";
	my @cellinfor="";
print OUT "\#\#gff-version 3\n";
my $locusct=1;
	while ($word=<DNAhand>){ 	
		chomp $word;		
		my @cellinfor=split("\t",$word);
		unless ($word =~/Name	Seq_Len	StartPos	EndPos	Repetitions	Motif/){
			$cellinfor[0]=~ s/\>//;
			print OUT $cellinfor[0], "\t", "GMATA", "\t"; #collumn 1-2
			print OUT "SSR", "\t"; #collumn 3
			print OUT $cellinfor[2], "\t", $cellinfor[3], "\t"; #collumn 4-5
			print OUT "\.", "\t", "\.", "\t","\.", "\t"; #collumn 6-8			
			my $description="SSR"."$locusct"."\|".$cellinfor[4]."\:".$cellinfor[5]."\@".$cellinfor[0]."\:".$cellinfor[2]."\.\.".$cellinfor[3];
			my $name="SSR"."$locusct";
			my $ID=$name."\|".$cellinfor[4]."\:".$cellinfor[5];
			print OUT "Name\=$name\;","ID\=$ID\;","Note\=",$description,"\n"; #collumn 9
			$locusct++;
		}	
    } #end while	
sub usageinfo{
		my @usage=(); # showing content on how to use the programme
		$usage[0]="Usage: generate gff3 format file based on ssr loci file\n";
		$usage[1]=" for    help: perl $0 ; \n";
		$usage[2]=" for running: perl $0 -i [ssr loci file] \n";
		$usage[3]="e.g.:  perl ssr2gff3.pl -i testseq.fasta.ssr\n";
		$usage[4]="Author: Xuewen Wang\n";
		$usage[5]="year 2013 May,2014 April.\n";
		unless(@ARGV){print @usage; exit;} 
 } #end sub
exit;
