#PBS -N ssrMsk
#PBS -l walltime=10:00:00
#PBS -l mem=2gb

##PBS -q bennetzen_q
##PBS -l nodes=1:ppn=1

##PBS -q highmem_q
##PBS -l nodes=1:ppn=20:AMD
#PBS -q batch
#PBS -l nodes=1:ppn=1:AMD
##PBS -l nodes=1:ppn=8:Intel

###queue: batch: AMD 48core128G; Intel 28Core,64G; 
##queue: highmem_q: 48core512G HIGHMEM,AMD ; 28core1TB HIGHMEM,Intel
######This is the piple line for Bam file to fasta
##scriptdir: /lustre1/xwwang/Pglandulosa/scripts
##dir :
##mbase
##--------seq
scriptdir=/media/xuewen/XW18T/XW10T_bkp/XW10T/cpapyrus_hifi/RepeatSeq_analysis/scripts

#for linux, ssr masking in the sequence
#ssrtooldir=/scratch/xwwang/GMATA2.2
ssrtooldir=/media/xuewen/XW18T/XW10T_bkp/XW10T/cpapyrus_hifi/RepeatSeq_analysis/GMATA2.2
cd $ssrtooldir

seqdir=/media/xuewen/XW18T/XW10T_bkp/XW10T/cpapyrus_hifi/CP_PBccs_assembly/TEanalysis
genomeseq="cpapyrus.hifiasm.bp.pctg.fa"

##rename the file to universal name
seq="gseq.fa"
cp $seqdir/$genomeseq $seqdir/$seq
#perl gmata.pl -c default_cfg2.2.txt -i $seqdir/pros.v1.1.unitigs.consensus.fasta 
perl $ssrtooldir/gmata.pl -c default_cfg2.2.txt -i $seqdir/$seq 
##resultdir: $seqdir
##result: hard masked SSR
#$seq.ssrMasked.fasta

cd $seqdir
printf "old id:\n"
grep ">" $seqdir/$seq.ssrMasked.fasta|head
echo

##change id : remove ""|arrow"
cat $seqdir/$seq.ssrMasked.fasta | sed 's/|arrow//'  >${seq/.fa/}.ssrMasked.fa


printf "new id:\n"
grep ">" ${seq/.fa/}.ssrMasked.fa|head
printf "new seq after SSR hard masking:\n"
echo $seqdir
echo ${seq/.fa/}.ssrMasked.fa
##final file:
##pros.v1.1.contigs.consensus.nid.ssrMasked.fa
rm $seqdir/$seq.ssrMasked.fasta
rm $seqdir/$seq.fms



