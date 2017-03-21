#!/usr/bin/perl -w
use strict;
&usageinfo();
	my %commandin = @ARGV;
	if ((scalar @ARGV)%2 != 0){print "arguments must be in pair";}
	my $refin=$commandin{"-i"}; #information of input file
	my $refin_frg=$commandin{"-f"}||"$refin.eMap.frg"; # input file .frg	
	my $outputfile=$refin.".gff3";
	open (DNAhand,$refin)|| die (" $0 file opening failed, please check");
	open (OUT,">$outputfile")|| die (" $0 file writing failed, please check"); # gff3 data file name
	print "Producing Growse gff3 file (.gff3). \n Output files: \n $outputfile\n";
	my %idin_allele=();
	my %idin_frg=();
	open (FRGhand, $refin_frg)|| die (" $0 file opening failed, please check");
	while (my $wordin=<FRGhand>){ 	
		chomp $wordin;		
		my @cellinforin=split("\t",$wordin);
		my $idin=$cellinforin[0];
		$idin_frg{$idin}=$cellinforin[1];
		$idin_allele{$idin}=$cellinforin[2];		
	} #end while
	close FRGhand;
	my $word="";
	my @cellinfor="";
print OUT "\#\#gff-version 3\n";
my $locusct=1;
my %allseqinformation= ();
	while ($word=<DNAhand>){ 	
		chomp $word;		
		my @cellinfor=split("\t",$word);
		unless ($word =~/SequenceID 	MarkerID	PRIMER_LEFT_SEQUENCE/){
		if(length $cellinfor[1]){
			$cellinfor[0]=~ s/\>//; #Chr1|10000348:10000763|10000548:10000563
			my @readpart1=split ('\|',$cellinfor[0]); #Chr1 10000348:10000763 10000548:10000563
			my @pos=split ('\:',$readpart1[1]);# 10000348:10000763, flanking template
			my $lprimerpos=$pos[0]+$cellinfor[6]+1;
			my $rprimepos=$pos[0]+$cellinfor[7]+1;
			my $mkregion=$readpart1[0]."_".$lprimerpos."_".$rprimepos;				
			if(! exists $allseqinformation{$mkregion}){
				$allseqinformation{$mkregion}=1;
				print OUT $readpart1[0], "\t", "GMATA\t", "SSR_marker\t",$lprimerpos,"\t",$rprimepos,"\t"; 
				print OUT "\.", "\t", "\.", "\t","\.", "\t"; #collumn 6-8
				$cellinfor[1]=~ s/\>//; #mk name
				my $name=$cellinfor[1]; #MK1
				my $ID="SSRloci".$readpart1[2];#10000548:10000563
				my $pl="Primer_L ".$cellinfor[2]."\, Tm ".$cellinfor[3]." ";
				my $pr="Primer_R ".$cellinfor[4]."\, Tm ".$cellinfor[5]." ";
				my $pcrsize="Size(bp) ".$cellinfor[8];
				my $name_fasta='>'.$name;
				my $description=$pl."\,".$pr."\,".$pcrsize."\,Alleles count\(s\)  ".$idin_frg{$name_fasta}.","."Allele size\(s\)\(bp\)\/designed,".$idin_allele{$name_fasta};			
				print OUT "Name\=$name\;","ID\=$ID\;","Note\=",$description,"\n"; #column 9
			} #end if exists
			$locusct++;
		}# end if
		}	#end unless
    } #end while
sub usageinfo{
		my @usage=(); # showing content on how to use the programme
		$usage[0]="Usage: generate gff3 format file based on ssr loci file\n";
		$usage[1]=" for    help: perl $0 ; \n";
		$usage[2]=" for running: perl $0 -i [prefix.ssr.finalPrimer.txt] \n";
		$usage[3]="e.g.:  perl mk2gff3.pl -i testseq.fasta.ssr.finalPrimer.txt\n";
		$usage[4]="Author: Xuewen Wang\n";
		$usage[5]="year 2013 May, 2014 April\n";
		unless(@ARGV){print @usage; exit;} 
 } #end sub
exit 0;
