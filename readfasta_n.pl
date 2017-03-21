#!/usr/bin/perl -w
use strict;
usageinfo();
my %commandin = @ARGV;
if ((scalar @ARGV)%2 != 0){print "arguments must in pair\n";}
my $refin=$commandin{"-i"}; 
my $formattype=$commandin{"-f"}; 
my $lenornot=$commandin{"-len"}||"F";
my $idtrim=$commandin{"-id"}||"F";
my $outputfile=$commandin{"-o"};
 unless(-e $refin){print "Sequence file does not exist in the working directoty\n";}
 open(OUT, ">$outputfile")|| die (" Write file failed, pleasse check\n");
 open(OUTLOG, ">$outputfile\.log")|| die (" Write file failed, pleasse check\n");
 if ($formattype!=1 and $formattype!=2){print OUT "format must be 1 or 2\n"; exit;}
 my $filename=$refin;
open(FILE, $filename) || die("Couldn't read file $filename\n"); 
local $/ = "\n>";  
my $newID ="";
&runtime(\*OUTLOG);
while (my $seqinfo = <FILE>) {
chomp $seqinfo;      
    $seqinfo =~ s/^>*(.+)\n//; 
     my $seqID=">".$1; 	 
	 if ($idtrim eq "T"){
		my @seqIDcontn=split('\s',$seqID); #truncate seqID by first space
		$seqID=$seqIDcontn[0];
	 }
	    $seqinfo=~ s/[0-9\n\s]//g;  
     my $seq=$seqinfo;
     my $seqlength=length $seq;
     if ($lenornot eq "T"){$newID=$seqID."\|".$seqlength;}
     else{$newID=$seqID;}
     if ($formattype==1){print OUT $newID,"\t", $seq, "\n"; }
     elsif($formattype==2){print OUT $newID,"\n", $seq, "\n";}
     else{print OUT "wrong value for -f: must be 1 or 2\n";}  
}
close FILE;
close OUTLOG;
close OUT;
sub usageinfo
 {
 my @usage=(); 
 $usage[0]="Usage: format sequences to multiple format. ";
 $usage[1]=" for    help: perl $0 ; \n";
 $usage[2]=" -len value take T or F. T means the seq ID will be added length information '|#'; otherwise 'F', not length information";
 $usage[3]=" -f has two value 1 or 2. 1 means seq ID and seq in one line seperated by tab; 2 means seq ID and seq in two seperate lines";
 $usage[4]=" for running: perl $0 -i [input fasta-like file name ] -f [1 or 2] -id trimID_orNot_TorF -len [length information added: if set to 'T']  -o [file name after extracting] \n";
 $usage[5]="Author: Xuewen Wang\n";
 $usage[6]="year 2009-2011, 2013 Nov\n";
 unless(@ARGV){print @usage; exit;} 
 }
sub runtime(){
	my $OUTfile=shift @_;
	my $local_time = gmtime();
	print {$OUTfile} "$0 was run. Current time is $local_time\n";
}
exit;

