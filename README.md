# GMATA
### GMATA stands for Genome-wide Microsatellite Analyzing Toward Application. GMATA is an easiest and fastest bioinformatic tool /software for any Simple Sequence Repeats (SSR) analyses, and SSR marker designing, polymorphism screen, and e-mapping in any DNA sequences. GMATA algorithms have been cited wordwide for more than 180 times in academic publication. 

### GMATA uses a range of algorithms to identify tandem repeats and analyze their characteristics, such as the length and purity of the repeat sequence. It can be used to analyze both single sequences and whole genomes, and provides a range of output formats and visualization tools for further analysis.

### Overall, GMATA is a useful tool for researchers studying the genetics and genomics of various organisms, as it provides a comprehensive analysis of tandem repeat sequences that can help elucidate their functional and evolutionary significance.

### You can run the GMATA from graphic interface or command interface. 

Latest version: v2.3. 

Developed by Xuewen Wang.

## News
A new updated version which  works on most Linux systems is coming soon. Genoytping specified tandem repeat (TR) sites from NGS platforms can be done using our newest online tool [TRcaller](www.TRcaller.com), which is the fastest and most accurate tool for TR genotyping for both short and long NGS sequencing reads.

## Install for Windows, Linux and Mac OS
You can use one of the following methods.

Method 1:

Directly download all files into directory callled GMATA in your computer

Method 2:
 `git clone https://github.com/XuewenWangUGA/GMATA`

 `cd GMATA`
 
 For Linux and Mac OS X, you may need to install additional dependency primer3 and e-PCR.zip which is alvailable at [Sourceforge](https://sourceforge.net/projects/gmata/). Linux like systems have to install primer3 depdency. As the latest primer3 IO is changed and compatible to 4 only, the latest Primer3 is not working properly at the moment. Please use the tested version of primer3 (primer3-2.2.3.tar.gz) coming with this package and install it. Tool e-PCR is also included now for those who needs to install in Linux. The instructions for install primers and e-PCR are included after decompressing the .gz or .zip file. 
 
 For Windows, everthing is in the package so you don't need to install additional dependency. 
 
[more detailed installation steps](GMATA_installation.pdf)

## Requirements for the latest version of GMATA:
Java runtime version 60 or above coming with latest java jdk 16

latest perl 5.##, do not use perl 6.##

latest python3: version 3.6 or above; do not use python 2

latest biopython for python3

latest R 4.##





## GMATA can be fully run at one of the three ways:
1. run at the graphic interface: This is recommended for who do have programming skills. Only mouse click is needed for this method to run GMATA.
or
2. run all commands by a single step: This can run batchly and integrate into your pipeline. 
or
3. step by step command
 
 ## Run graphic interface
 `java -jar GMATAv2.3.jar`
 or double click the `GMATA#.jar`, where # is the version number, e.g. `GMATAV2.2.1.jar`

Then you will see the following interface
![What is this](GMATA_gui2.3.png)

 
 ## Run command interface
 `perl gmata.pl -c default_cfg.txt -i ..\data\testseq.fasta`
 
  where -c parameter is for config file. More details and demonstration on [user manual](GMATA%manual_V2.01_20151218.pdf)
 File: GMATA%manual_V2.01_20151218.pdf
 
 ## Step by Step
 Please followed the steps in manual and demo.
 
 ## SSR mask for genomic sequence
 
 This is a new function added for discovery and mask genome-wide SSRs
 
 `perl gmata.pl -c default_cfg2.2.txt -i /path/gseq.fa`

## Updates on version 2.3: works for fasta , fastq files
Updated the graphic interface and new module for fastq processing. Fullly updated and compatible with all major versions of Linux including Ubuntu. 
A new module for converting sequence in fastq to fasta file is added into both command line and graphic interface. 
To use this function, please install [python3](https://www.python.org/downloads/) (version 3.6 or above) for Windows. For Linux and Mac OS, the Python3 may be installed by manufacter.
The new module is added in graphic interface which can be used by just mouse click.
For this new module in command line, please see the detailed usage at my Github [Sequence Reads Processing](https://github.com/XuewenWangUGA/SeqReadsProcessing)

## Updates on version 2.2.1
Updated the graphic interface. fixed the issue which may not start at particular version of Linux Ubuntu.

## Updates on version 2.2
1. add a new module for masking SSRs for genome annotation
2. add a new function for satelite analysing
3. add tools for mining SSRs in 2nd and 3rd genertation reads
4. new interface

## Main functions
This is the software GMATA at GitHUB
What is software GMATA
Genome-wide Microsatellite Analyzing Toward Application (GMATA) is a software for Simple Sequence Repeats (SSR or STR) identification, and SSR marker designing and polymorhism mapping in any DNA sequences, not matter how big your file is. It has the following functions:
1. SSR mining; good for all SSRs:microsatellites, satellites, any tadem repeats
2. Statistical analysis and plotting;
3. SSR loci graphic viewing;
4. Marker designing;
5. ploymorphism screen;
6. Electronic mapping and marker transferability investigation.
7. Sequence file format conversion: Fastq to fasta

GMATA is accurate, sensitive and fast. It was designed to process large genomic sequence data sets, especially large whole genome sequences. In theory, genomes of any size can be analyzed by GMATA easily. Software GMATA works on sever, desktop or even laptop, and it can run in graphic interface with just clicks or run in command line or in automated pipeline. It is also cross-platform and supports Unix/Linux, Win and Mac. Results from software GMATA can be directly graphically displayed with genome or gene features in Gbrowser and easily integrated with any genomic database.

## Citing this software:
GMATA: an integrated software package for genome-scale SSR mining, marker development and viewing
X Wang, L Wang
[Frontiers in Plant Science 7, doi 10.3389/fpls.2016.01350](http://journal.frontiersin.org/article/10.3389/fpls.2016.01350/full)

The software has been cited more than 160 times in published papers. To see which publication cited GMATA and GMATo, click here at [Xuewen Wang Google scholar page](https://scholar.google.com/citations?user=jXfdcm0AAAAJ&hl=en)

## Alternative downloading link for this software 
[Sourceforge](https://sourceforge.net/projects/gmata/)


## Features
Accurate and fastest SSR mining in any large sequences in fasta or fastq format from NGS sequencing platforms
Complete statistical analysis and plotting
SSR loci and marker graphic displaying in Gbrowser with genome features
Specific SSR marker designing, and simulated PCR
Electronic mapping, and marker transferability investigation


## Discussion
[sourceforge discussion](https://sourceforge.net/p/gmata/wiki/Home/)

## Testing data
To make a test run: go to web https://sourceforge.net/projects/gmata/files/?source=navbar 
to download the test data called "datav21.zip"
or download the "testseq.fasta" and then put a separately folder e.g. "data" instead of running in the source script, otherwise  all lots of results will write to the same directory. Of course, it will run well if you still want to keep running the analysis on "testseq.fasta"" in the installed software directory.
