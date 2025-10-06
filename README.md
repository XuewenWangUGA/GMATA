# GMATA
### GMATA stands for Genome-wide Microsatellite Analyzing Toward Application. GMATA is the easiest and fastest bioinformatic tool /software for any Simple Sequence Repeats (SSR) analyses, and SSR marker designing, polymorphism screening, and e-mapping in any DNA sequences. GMATA algorithms have been cited worldwide more than 300 times in academic publications. 

### GMATA uses a range of algorithms to identify tandem repeats and analyze their characteristics, such as the length and purity of the repeat sequence. It can be used to analyze both single sequences and whole genomes, and provides a range of output formats and visualization tools for further analysis.

### Overall, GMATA is a useful tool for researchers studying the genetics and genomics of various organisms, as it provides a comprehensive analysis of tandem repeat sequences that can help elucidate their functional and evolutionary significance.

### You can run the GMATA from a graphic interface or a command interface. 

Latest version: v2.3. 

Developed by Xuewen Wang.

## News
A new updated version that  works on most Linux systems, Windows, and macOS. 

Genotyping specified tandem repeat (TR) sites from Next Generation Sequencing platforms can be done using the command line from Github https://github.com/XuewenWangUGA/TRcaller. TRcaller, which is the fastest (300x human genome sequencing data for 2 seconds for 20 [CODIS](https://www.fbi.gov/how-we-can-help-you/dna-fingerprint-act-of-2005-expungement-policy/codis-and-ndis-fact-sheet) STRs) and most accurate tool by far for TR genotyping for both short and long NGS sequencing reads.

## GMATA install for Windows, Linux, and Mac OS
You can use one of the following methods.

Method 1:

Directly download all files into a directory called GMATA and run in this directory on your computer

Method 2:
 `git clone https://github.com/XuewenWangUGA/GMATA`

 `cd GMATA`
 
 For Linux and Mac OS X, you may need to install additional dependencies primer3 and e-PCR.zip, which is available at [Sourceforge](https://sourceforge.net/projects/gmata/). 
 
 Alternatively, unzip the e-PCR.zip, copy the already pre-compiled executable files downloaded here for Linux to the GMATA directory. A precompiled primer3 for Linux is already provided, and needed to copy the executable files to the GMATA directory. Linux-like systems have to install the primer3 dependency. As the latest Primer3 IO is changed and compatible to 4, the latest Primer3 is not working properly at the moment. Please use the tested version of primer3 (primer3-2.2.3.tar.gz) coming with this package and install it. The tool e-PCR is also included now for those who need to install it in Linux. The instructions for installing primers and e-PCR are included after decompressing the .gz or .zip file. 
 
 For Windows, everything is in the package, so you don't need to install additional dependencies. 
 
[more detailed installation steps](GMATA_installation.pdf)

## Requirements for the latest version of GMATA:
Java runtime version 60 or above, coming with the  latest Java JDK 16

latest perl 5.##, do not use perl 6.##

latest python3: version 3.6 or above; do not use python 2

latest biopython for python3

latest R 4.##





## GMATA can be fully run in one of the three ways:
1. run at the graphic interface: This is recommended for those who have programming skills. Only a mouse click is needed for this method to run GMATA.
or
2. run all commands by a single step: This can run batchly and integrate into your pipeline. 
or
3. step-by-step command
 
 ## Run graphic interface
 `java -jar GMATAv2.3.jar`
 or double click the `GMATA#.jar`, where # is the version number, e.g. `GMATAV2.2.1.jar`

Then you will see the following interface
![What is this](GMATA_gui2.3.png)

 
 ## Run command interface
 `perl gmata.pl -c default_cfg.txt -i ..\data\testseq.fasta`
 
  where the -c parameter is for the config file. More details and demonstration on [user manual](GMATA%manual_V2.01_20151218.pdf)
 File: GMATA%manual_V2.01_20151218.pdf
 
 ## Step by Step
 Please follow the steps in the manual and demo.
 
 ## SSR mask for genomic sequence
 
 This is a new function added for discovery and masking genome-wide SSRs for subsequent repetitive analysis.
 
 `perl gmata.pl -c default_cfg2.2.txt -i /path/gseq.fa`

 or run a separate run based on existing GMATA output: 
 
 'perl gssrmsk.pl -i gseq.fa -s 2 >run_log.txt'

  -s 2 for hard masking or -s 1 for softmasking, or -s 0 for no masking

## Updates on version 2.3: works for .fasta and .fastq files
Updated the graphic interface and new module for fastq processing. Fully updated and compatible with all major versions of Linux, including Ubuntu. 
A new module for converting a  sequence in fastq to a  fasta file has been added to both the command line and the graphic interface. 
To use this function, please install [python3](https://www.python.org/downloads/) (version 3.6 or above) for Windows. For Linux and Mac OS, Python 3 may be installed by the manufacturer.
The new module has been added to the graphic interface, which can be used with just a mouse click.
For this new module in the command line, please see the detailed usage at my GitHub [Sequence Reads Processing](https://github.com/XuewenWangUGA/SeqReadsProcessing)

## Updates on version 2.2.1
Updated the graphic interface. Fixed the issue that may not start at a particular version of Linux Ubuntu.

## Updates on version 2.2
1. Add a new module for masking SSRs for genome annotation
2. Add a new function for satellite analysis
3. Add tools for mining SSRs in 2nd and 3rd generation reads
4. new interface

## Main functions
This is the software GMATA on GitHub
What is software GMATA
Genome-wide Microsatellite Analyzing Toward Application (GMATA) is a software for Simple Sequence Repeats (SSR or STR) identification, and SSR marker designing and polymorphism mapping in any DNA sequence, no matter how big your file is. It has the following functions:
1. SSR mining; good for all SSRs: microsatellites, satellites, any tandem repeats
2. Statistical analysis and plotting;
3. SSR loci graphic viewing;
4. Marker designing;
5. Polymorphism screen;
6. Electronic mapping and marker transferability investigation.
7. Sequence file format conversion: Fastq to fasta

GMATA is accurate, sensitive, and fast. It was designed to process large genomic sequence data sets, especially large whole-genome sequences. In theory, genomes of any size can be analyzed by GMATA easily. Software GMATA works on a server, a desktop, or even a laptop, and it can run in a graphical interface with just clicks or run in a command line or in an automated pipeline. It is also cross-platform and supports Unix/Linux, Win, and Mac. Results from software GMATA can be directly graphically displayed with genome or gene features in Gbrowser and easily integrated with any genomic database.

## Citing this software:
GMATA: an integrated software package for genome-scale SSR mining, marker development, and viewing
X Wang, L Wang
[Frontiers in Plant Science 7, doi 10.3389/fpls.2016.01350](http://journal.frontiersin.org/article/10.3389/fpls.2016.01350/full)

The software has been cited more than 300 times in published papers. To see which publication cited GMATA and GMATo, click here at [Xuewen Wang Google scholar page](https://scholar.google.com/citations?user=jXfdcm0AAAAJ&hl=en)

## Alternative downloading link for this software 
[Sourceforge](https://sourceforge.net/projects/gmata/)


## Features
Accurate and fastest SSR mining in any large sequences in fasta or fastq format from NGS sequencing platforms
Complete statistical analysis and plotting
SSR loci and marker graphic displayed in Gbrowser with genome features
Specific SSR marker designing and simulated PCR
Electronic mapping and marker transferability investigation


## Discussion
[sourceforge discussion](https://sourceforge.net/p/gmata/wiki/Home/)

## Testing data
To make a test run: go to the web https://sourceforge.net/projects/gmata/files/?source=navbar 
to download the test data called "datav21.zip"
Or download the "testseq.fasta" and then put a separate folder, e.g., "data", instead of running in the source script; otherwise,  all results will be written to the same directory as the input sequence is located. Of course, it will run well if you still want to keep running the analysis on "testseq.fasta" in the installed software directory.
