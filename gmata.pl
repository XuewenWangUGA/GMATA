#!/usr/bin/perl -w
use strict;

#configure file format: 
# each block starts with [set]:gmat, then followed by lines by parameter and its value pair
#e.g.
# [set]:gmat
# #1. gmat.pl-------------------------------------------------------------------------------------------
# gmat.pl = Y|N	
# following options won't work unless above VALUE is Y
# then list the parameters and their values in next lines
# -r = 5


# for Usage help: perl gmata.pl
# e.g. perl gmata.pl -c default_cfg.txt -i ..\data\testseq.fasta
&usageinfo();


# get command options
	my %commandin = @ARGV;
	if ((scalar @ARGV)%2 != 0){print "arguments must be in pair";}
	my $cfg=$commandin{"-c"}||"default_cfg.txt"; #information of input file
	my $inputseq=$commandin{"-i"}||"testseq.fasta"; #information of input file
	print "Your running: perl gmata.pl -c $cfg -i $inputseq\n";

	
# file status check and preparation
	open (DNAhand,$cfg)|| die (" $0 file opening failed, please check");

#definition
	my $word="";
	my @cellinfor="";	
	my $program="";
	my $torun="";
	my $programsetting="";
	my %run_info=();
	my $readinct=0;
	my $run_go="";

local $/="\[set\]\:";
# read in cfg data
	while ($word=<DNAhand>){ 	
		chomp $word;
		next if ($word=~/^\s*$/);
		
	 unless ($readinct == 0){ #ignore first read in		
		my @cellinfor=split("\n",$word);		
		undef my @parallinfo;
		foreach my $linein(@cellinfor){
			next if ($linein=~/^\s*$/ or $linein=~ /^\s*\#/); 
				$linein=~ s/\s//g; #remove space
				push (@parallinfo,$linein);			
		}
		#get all setting information
			$program=shift @parallinfo;
			$torun=shift @parallinfo;
			$programsetting=join(" ", @parallinfo);
			if ($torun eq "ModulRun=Y"){
				$run_info{$program}=$programsetting;
			}
	  } #end if for first read in
	  $readinct +=1;
    } #end while	

			my $sr=$inputseq."\.ssr";
			my $sat2=$sr."\.sat2";
			my $mk=$inputseq."\.ssr\.mk\.sts"; #
			my $mkgffinput=$inputseq."\.ssr\.mk";
			
			if(exists $run_info{gmat}){#gmat.pl
				$run_go= "perl gmat.pl "."$run_info{gmat} -i $inputseq";	
				&run_module(\$run_go);
			}

			if(exists $run_info{gssrmsk} ){#gssrmsk
				$run_go= "perl gssrmsk.pl "."$run_info{gssrmsk}";
				&run_module(\$run_go);
			}
			
			if(exists $run_info{ssrfig} ){#ssrfig
				$run_go= "perl ssrfig.pl "."$run_info{ssrfig} -i $sat2";				
				&run_module(\$run_go);
			}
			
			if (exists $run_info{ssr2gff}){#ssr2gff
				$run_go= "perl ssr2gff.pl ". "$run_info{ssr2gff} -i $sr";				
				&run_module(\$run_go);
			}			
			if(exists $run_info{ssr2gff3}){#ssr2gff3
				$run_go= "perl ssr2gff3.pl ". "$run_info{ssr2gff3} -i $sr";				
				&run_module(\$run_go);
			}
			
			if (exists $run_info{doprimer_smt}){#doprimer_smt
				$run_go= "perl doprimer_smt.pl ". "$run_info{doprimer_smt} -i $inputseq -sr $sr";
				&run_module(\$run_go);
			}
						
			if (exists $run_info{elctPCR}){#elctPCR
				if ($run_info{elctPCR} =~ s/\-i\=\s\-/-/){#empty, till next par starting with -. go to default
					$run_go= "perl elctPCR.pl ". "$run_info{elctPCR} -i $inputseq -mk $mk";					
				}else{#user
					$run_go= "perl elctPCR.pl ". "$run_info{elctPCR} -mk $mk";	
				}
				&run_module(\$run_go);
			}
			
			if (exists $run_info{mk2gff3}){#mk2gff3
				$run_info{mk2gff3} =~ s/\-o\=//;
				my $tagfrg=$inputseq."\.$run_info{mk2gff3}"."\.frg";
				$run_info{mk2gff3}="-f $tagfrg";				
				$run_go= "perl mk2gff3.pl ". "$run_info{mk2gff3} -i $mkgffinput";
				&run_module(\$run_go);				
			}
			

			
sub run_module(){
	my $run_call=${shift @_};
	$run_call=~ s/\=/ /g;
	system($run_call) ==0 or die ("system $run_call failed: $?");
}
sub usageinfo{
		my @usage=(); # showing content on how to use the programme
		$usage[0]="Usage: GMATA: one step software.\n";
		$usage[1]=" for    help: perl $0 \n";
		$usage[2]=" for running: perl $0 -c config_file -i input_sequence_file \n";
		$usage[3]=" e.g.: perl gmata.pl -c default_cfg.txt -i testseq.fasta\n";
		$usage[4]="Author: Xuewen Wang\n";
		$usage[5]="Year 2013. Nov\n";
		unless(@ARGV){print @usage; exit;} 
 } #end sub 
 unlink "$inputseq.seq", "$inputseq.fms","$inputseq.fms.log";
print "Done all.\n";
exit 0;
