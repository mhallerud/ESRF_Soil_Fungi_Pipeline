#!/bin/bash
lib=$1 #library directory

FWD="GGAAGTAAAAGTCGTAACAAGG"
REV="CAAGAGATCCGTTGTTGAAAGTT"
FRC="$(echo $FWD | rev | tr [ATCG] [TAGC])"
RRC="$(echo $REV | rev | tr [ATCG] [TAGC])"

OUT="$(echo $lib | sed 's/LIB_//')_cutadapt.txt"

[[ -d "$lib"/cutadapt ]] || mkdir $lib/cutadapt

for f in `ls -1 $lib/*fastq | cut -d'.' -f1`; do
	#--max-n: cutoff number of 'N' allowed per read
	#-n: searches for both FWD and REV to be removed from read
	#-o
	#-g: first primer on FWD reads (FWD primerseq)
	#-a: second primer on FWD reads (REV.RC primerseq)
	#-G: first primer on REV reads (REV primerseq)
	#-A: second primer on REV reads (FWD.RC primerseq)
	#-o: output for FWD reads
	#-p: output for REV reads
	f="$(basename $f)"
	echo "cutadapt $lib/$f.1.fastq $lib/$f.2.fastq --max-n 0 -g $FWD -a $RRC -G $REV -A $FRC -o $lib/cutadapt/$f.1.fastq -p $lib/cutadapt/$f.2.fastq -n4 -q 2 --minimum-length 50"
	#echo "cutadapt $lib/$f.rev.1.fastq $lib/$f.rev.2.fastq --max-n 0 -g $REV -a $FRC -G $FWD -A $RRC -o $lib/cutadapt/$f.rev1.1.fastq -p $lib/cutadapt/$f.rev1.2.fastq -n4"
	#echo "cutadapt $lib/cutadapt/$f.rev1.1.fastq $lib/cutadapt/$f.rev1.2.fastq -g $REV -G $FWD -o $lib/cutadapt/$f.rev.1.fastq -p $lib/cutadapt/$f.rev.2.fastq"
	#echo ""
done > $OUT
