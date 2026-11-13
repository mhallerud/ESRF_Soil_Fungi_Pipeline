#!/bin/bash
PREFIX=$1
FW=/nfs4/FW_HMSC/Levi_Lab/Illumina_Runs/Illumina83/${PREFIX}_R1_001.fastq
REV=/nfs4/FW_HMSC/Levi_Lab/Illumina_Runs/Illumina83/${PREFIX}_R2_001.fastq
ids=$2

dir="$(dirname $ids)"


# now let's extract all of the pair-able reads on a per sample basis
prefix="$(basename $ids | sed 's/.pear//' | sed 's/.ids//')";

# extract FW reads
grep -f $ids $FW -A3 --no-group-separator > $dir/$prefix.1.fastq;

# extract REV reads
sed 's/1:N:0:/2:N:0:/g' $ids > $dir/$prefix.2.pear.ids;
grep -f $dir/$prefix.2.pear.ids $REV -A3 --no-group-separator > $dir/$prefix.2.fastq;

