# PigNGSclean
NGS data cleaning on Apache Pig

## Single-read NGS data cleaning
Pig Latin script for reading, cleaning, and storing operations for the single-read NGS data.

```Pig Latin
REGISTER PigNGSclean.jar;
IMPORT 'NGSCleanMacros.pig';

d = loadSingleRead('/data/SRR988074_1.fastq.rowq');

o = processSingleRead(d, 
    'ILLUMINACLIP:TruSeq3-SE:2:30:10 
     TAILCROP:10 
     LEADING:20 
     TRAILING:20 
     SLIDINGWINDOW:4:20 
     MINLEN:30');

storeSingleRead(o, 'Out1');

```

## Paired-end NGS data cleaning
Pig Latin script for reading, cleaning, and storing operations for the paired-end NGS data.

```Pig Latin
REGISTER PigNGSclean.jar;
IMPORT 'NGSCleanMacros.pig';

d1, d2 = loadPairedEnd(
            '/data/SRR988074_1.fastq.rowq', 
            '/data/SRR988074_2.fastq.rowq');

o1, o2 = processPairedEnd(d1, d2, 
    'ILLUMINACLIP:TruSeq3_PE:2:30:10 
     TAILCROP:10 
     LEADING:20 
     TRAILING:20 
     SLIDINGWINDOW:4:20 
     MINLEN:30');

storePairedEnd(o1, o2, 'Out1', 'Out2');
```

## Cleaning operations
The PigNGSclean library supports the following NGS data-cleaning operations:

* ILLUMINACLIP -- removes the given adapter sequences from the DNA read. The arguments are the name of the adapter set, a value specifying the maximum number of mismatches that will still allow a full alignment, a value specifying how close the match between two reads of the so-called combined adapter must be to match palindromic paired-end reads, and a value specifying how close the match between any adapter sequence and the read must be.
Adapter sets are predefined (identical to those supplied in the Trimmomatic tool):
    * NexteraPE-PE.fa,
    * TruSeq2-PE.fa,
    * TruSeq2-SE.fa,
    * TruSeq3-PE-2.fa,
    * TruSeq3-PE.fa,
    * TruSeq3-SE.fa.
* MINLEN -- discards a read if its length is less than the specified length.
* MAXLEN -- discards a read if its length exceeds the specified length.
* LEADING -- removes bases from the beginning of the read if their quality is less than the specified length.
* TRAILING -- removes bases from the end of the read if their quality is less than the specified length.
* CROP -- removes bases from the end of the read so that its length does not exceed the specified length.
* HEADCROP -- removes the specified number of bases from the beginning of the read.
* TAILCROP -- removes the specified number of bases from the end of the read.
* AVGQUAL -- discards the read if its average quality is less than the specified length.
* MAXINFO -- uses an adaptive approach that balances the read length and error rate to maximize its value. It takes as arguments an integer value specifying the target read length and a floating point value in the range (0;1), which affects the balance between length and quality.
* SLIDINGWINDOW -- performs cleaning based on a window that slides through the read from the beginning and truncates it when the average quality in the window falls below the specified value.The arguments are the window length and the desired average quality.


