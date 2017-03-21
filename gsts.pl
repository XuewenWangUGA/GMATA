#!/usr/bin/perl -w
use strict;
	&usageinfo();
	my %commandin = @ARGV;
	if ((scalar @ARGV)%2 != 0){print "arguments must be in pair";}
	my $refin=$commandin{"-i"}; #information of input file
	my $outputfile=$refin.".sat2";
	open (DNAhand,$refin)|| die (" $0 file $refin opening failed, please check");
	open (OUTstat,">$outputfile")|| die (" $0 file writing failed, please check");
	my $word="";
	my $freqref="";
	my $freqref_name ="";
	my $freqref_subunit="";
	my $freqref_unitlen="";
	my $freqref_subunit_motif="";
	my $freqref_ssrlocilen="";
	my @name=(); 
	my @subunit=(); 
	my @unitlen=();
	my @locilen=();
	my %seq_len=();
	my $totalmotif=0;
	my $motifunitlen=0;
	my $t=0;#repetitions
	my $L=0; #SSR length
	my $N=0; #genome size
	my $genomsize=0; #to get from .sat1
	my %dwfsingle=();
	my $seqfilename=$refin=~s/\.ssr//;	
	my $seqsat1=$refin."\.fms\.sat1";
	$genomsize=${&read_sat1file(\$seqsat1)}||1000000;
	
	while ($word=<DNAhand>){ 	
		chomp $word;
		if($word =~ /^\>.+/){ 
			my @cellinfor=split("\t",$word);
				push (@name, $cellinfor[0]); #name of ID, ok
				if (!exists $seq_len{$cellinfor[0]}){
					$seq_len{$cellinfor[0]}=$cellinfor[1];
				}# get sequence length
				push (@subunit, $cellinfor[5]); 
				$motifunitlen=length $cellinfor[5];
				push (@unitlen, $motifunitlen); 
				my $ssrloilen=$cellinfor[3]-$cellinfor[2]+1; 
				push (@locilen, $ssrloilen); 
			   $totalmotif++;			   
			   my $repet=$cellinfor[4];
			   my $ssr_len=$motifunitlen*$repet;
			   my $dwfref=&dewachter($repet,$motifunitlen,$ssr_len,$genomsize);#single loci
			   if(! exists $dwfsingle{$motifunitlen}){
					$dwfsingle{$motifunitlen}=${$dwfref};
			   }else{
					$dwfsingle{$motifunitlen}+=${$dwfref};
			   }
			   
		}else{
		next; #ignore the highlighted lines if -s 1 was used in motif mining
		}
	} #end while
	$freqref_unitlen = &fre_ct_batch(\@unitlen); #count mers occurrence
	$freqref_subunit = &fre_ct_batch(\@subunit); #count motif occurrence
	$freqref_ssrlocilen = &fre_ct_batch(\@locilen); #count locilen occurrence
	$freqref_subunit_motif = &fre_ct_batch_motif($freqref_subunit); 
	$freqref_name = &fre_ct_batch(\@name);  
	&runtime(\*OUTstat);# for running log
	print OUTstat "Table 1\n";
	print OUTstat "Motif(-mer)\tTotal\tPercentage\tDWF_expect\n";
	&val_ascend_dewachter($freqref_unitlen,\*OUTstat); #sort and print, integrated for dewachter	
	print OUTstat "\n";
	print OUTstat "Table 2\n";
	print OUTstat "Motif\tTotal\tPercentage\n";
	&val_ascend($freqref_subunit, \*OUTstat); #sort and print
	print OUTstat "\n";	
	print OUTstat "Table 3 paired\n";
	print OUTstat "Grouped_Motif\tTotal\tPercentage\n";
	&val_ascend($freqref_subunit_motif,\*OUTstat); #sort and print
	print OUTstat "\n";
	print OUTstat "Table 4\n";
	print OUTstat "SeqID\tSSR_loci\tLoci_percentage\tSeqSize\tFrequency\(SSRs\/Mb\)" ,"\n";
	&val_ascend_mb($freqref_name,\*OUTstat,\%seq_len);
	print OUTstat "\n";
	print OUTstat "Table 5\n";
	print OUTstat "SSR_loci_length\tTotal_loci\tPercentage\n";
	&val_ascend($freqref_ssrlocilen,\*OUTstat); #sort and print
	close 	DNAhand;
	exit;
	
	
	sub read_sat1file(){
		my $satdescript=""; 
		my $satseqlen=0;
		my $filesat1=${shift @_}; #ref		
		open(SATIN, $filesat1)||die (" $0 file $filesat1 opening failed, please check");
		while(my $satword_line=<SATIN>){
			chomp $satword_line;
			if($satword_line =~ /^total length.+/){ 
				($satdescript,$satseqlen)=split('\t',$satword_line);
		}		
		}#endwhile
		close SATIN;
		return \$satseqlen;			
	}
	
	sub dewachter(){
		my ($st,$sml,$sL,$sN)=@_;
		my $dwf=0;
		my $p=0; 
		my $pm=0;
		my $pmt=0;
		my $sect2=0;
		my $NN=0;		
		$p=4**$sml;#power(4,sml),64=4^3 for tri
		$pm= 1/$p;#1/power(4,L) or p(M), probability of whole , 1/64 for tri
		$pmt= (1/$p)**$st;#power(1/(power(4,L),t)
		$sect2= 1-$pm;#[1-p(M)]
		$NN=$sN-$st*$sL-2*$sL+1;#N'=N-tL-2L+1		
		$dwf=$pmt*$sect2*($NN*$sect2+2*$sL); #p1
		#$dwf=$pmt*$sect2*$NN*($sect2+2*$sL);  #p2
		return \$dwf;	
	}
	
	sub val_ascend(){ #sort
		my ($fref,$outfile)=@_;
		my %refhash=%{$fref};
		my $value_total=0;
		my $key_ct=0;
		my $totalpercentage=0;
		my $percentage=0;
		foreach  my $key(sort {$refhash{$b} <=> $refhash{$a}} keys %refhash){
		    $percentage=$refhash{$key}/$totalmotif*100; 
			print {$outfile} $key ,"\t", $refhash{$key}, "\t",$percentage,"\n"; #updated on Jan 22 2013
			$value_total =$refhash{$key}+$value_total;
			$key_ct =$key_ct+1; 
			$totalpercentage=$percentage+$totalpercentage;
		}
		print {$outfile} "total_above\ttotal_above\ttotal_above\n";
		print {$outfile} $key_ct, "\t",$value_total,"\t",$totalpercentage,"\n";
	} #end sub
	
	sub val_ascend_dewachter(){ #sort
		my ($fref,$outfile)=@_;
		my %refhash=%{$fref};
		my $value_total=0;
		my $key_ct=0;
		my $totalpercentage=0;
		my $percentage=0;
		foreach  my $key(sort {$refhash{$b} <=> $refhash{$a}} keys %refhash){
		    $percentage=$refhash{$key}/$totalmotif*100; 
			print {$outfile} $key ,"\t", $refhash{$key}, "\t",$percentage,"\t"; 
			print {$outfile} $dwfsingle{$key}/$refhash{$key},"\n" ;#integrated dewacher 	 expected value,updated on April 14 2014
			$value_total =$refhash{$key}+$value_total;
			$key_ct =$key_ct+1; 
			$totalpercentage=$percentage+$totalpercentage;
		}
		print {$outfile} "total_above\ttotal_above\ttotal_above\n";
		print {$outfile} $key_ct, "\t",$value_total,"\t",$totalpercentage,"\n";
	} #end sub
	sub val_ascend_mb(){ #sort
	my ($fref,$outfile,$seq_len_ref)=@_;
	my %refhash=%{$fref};
	my $value_total=0;
	my $key_ct=0;
	my $len_ct=0;
	my %seq_lensub=%{$seq_len_ref};
	my $percentage=0;
	my $totalpercentage=0;
	foreach  my $key(sort {$refhash{$b} <=> $refhash{$a}} keys %refhash){
			$percentage=$refhash{$key}/$totalmotif*100; 		
			print {$outfile} $key ,"\t", $refhash{$key}, "\t", $percentage,"\t",$seq_lensub{$key}, "\t", $refhash{$key}/$seq_lensub{$key}*1000000,"\n";
			$value_total =$refhash{$key}+$value_total;			
			$key_ct =$key_ct+1; 
			$len_ct=$len_ct+$seq_lensub{$key}; 
			$totalpercentage=$percentage+$totalpercentage;	
	} # end foreach
	print {$outfile} "total_above", "\t","total_above","\t","total_above","\t","total_above","\t", "average_frequency","\n";
	if($len_ct!=0){
		print {$outfile} $key_ct, "\t",$value_total,"\t",$totalpercentage,"\t",$len_ct,"\t", $value_total/$len_ct*1000000,"\n";}
} #end sub
	sub fre_ct_batch(){ 
		#definition
		my @cells=@{shift @_}; #ok
		my %allseqinformation= ();
		my $sword="";
		foreach $sword (@cells){
			if(! exists $allseqinformation{$sword}){$allseqinformation{$sword}=1;}
			else{$allseqinformation{$sword}++;}
		} #end each
		return \%allseqinformation;
	} # end sub
	sub fre_ct_batch_motif(){ 
		my %refhash=%{shift @_}; 
		my %refhashc=(); 
		foreach  my $key( keys %refhash){
			my $keytmp=$key;
			$keytmp=~tr/AGTC/TCAG/;
			my $key_cr=reverse $keytmp;
			my $pairkey=$key."\/".$key_cr;
			if($key ne $key_cr){ 
				if(exists $refhash{$key_cr}){			
					( $refhashc{$pairkey}=$refhash{$key_cr}+$refhash{$key})if($refhash{$key}!= -1); 
					$refhash{$key_cr}=-1; 			
				}else{ 
					( $refhashc{$pairkey}=$refhash{$key})if($refhash{$key}!= -1); 
				}
			}else{ 
				($refhashc{$pairkey}=$refhash{$key})if($refhash{$key}!= -1); 
			}
		} # end each
		return \%refhashc;
	} #end sub
	sub runtime() {
		my $OUTfile=shift @_;
		my $local_time = gmtime();
		print {$OUTfile} "$0 was run and results were yielded at $local_time\n";
	} # end sub
	sub usageinfo{
		my @usage=(); # showing content on how to use the programme
		$usage[0]="Usage: statistic analysis for result output from motif script gssrtrim.pl.\n";
		$usage[1]=" for    help: perl $0 ; \n";
		$usage[2]=" for running: perl $0 -i [ssr result file name from gssrtrim.pl] \n";
		$usage[3]="Author: Xuewen Wang\n";
		$usage[4]="year 2012, 2013 Nov\n";
		unless(@ARGV){print @usage; exit;} 
 } #end sub
 exit;