#!/usr/bin/python
import sys

from Bio import SeqIO

'''
FUNCTION:
This script will take the next generation sequencing reads, e.g. PacBio SMART sequencing reads, from the input file in fastq format
Then will convert into fasta format and write in the output file
Parameters: outseqf in_seqfile length_cutoff
USAGE: 
`python3 fq2fa.py OUT_file IN_seq_file length_cutoff`
Example on testing data:
`python3 fq2fa.py  testseq.fasta testdata_illumina_1.fq`
Path information could be added before the input and output file name if files are not in current directroy.
Version 2021-June 18th
# use python version 3
'''
__author__ ="Xuewen Wang"

usage=""" python3 fq2fa.py OUT_file_in_fasta IN_seq_file_in_fastq
          e.g.: python3 fq2fa.py ./testseq.filtered.fasta ./testseq.fastq 
          """
print(usage)

lengths = []
sumlen = 0
sumraw=0
ct=0
ctgood=0
minlen=1


outf = open(sys.argv[1], 'w')
for record in SeqIO.parse(sys.argv[2], "fastq"):
     ct +=1
     sumraw += len(record.seq)
     if int(len(record.seq)) > minlen:
          ctgood +=1
          lengths.append(int(len(record.seq)))
          sumlen += int(len(record.seq))
          SeqIO.write(record, outf, "fasta")

'Report stats'
n = sumlen/2
print("Total number of input sequences/reads:\t", ct)
print("Total length (bp) of input sequences/reads:\t", sumraw)
print("Total number of sequences/reads after filtering:\t", ctgood)
print("Total length (bp) of filtered sequences/reads:\t", sumlen)

'Count the N50 length'
total = 0
lengths.sort(reverse = True)
for x in range(len(lengths)):
     total += lengths[x]
     if total >= n:
          print("N50 length (bp): %i" % (lengths[x-1]))
          break 
