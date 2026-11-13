#!/bin/bash
sample=$1


grep '@M0' $sample.1.fastq > $sample.1.ids
grep '@M0' $sample.2.rev.fastq > $sample.2.rev.ids

cat $sample.1.ids $sample.2.rev.ids | cut -d' ' -f1 | sort | uniq -c | awk '{if($1==2) print $2}' > $sample.keep.ids

grep -f $sample.keep.ids $sample.1.fastq -A3 --no-group-separator > $sample.1.keep.fastq
grep -f $sample.keep.ids $sample.2.rev.fastq -A3 --no-group-separator > $sample.2.rev.keep.fastq



grep '@M0' $sample.1.rev.fastq > $sample.1.rev.ids
grep '@M0' $sample.2.fastq > $sample.2.ids

cat $sample.1.rev.ids $sample.2.ids | cut -d' ' -f1 | sort | uniq -c | awk '{if($1==2) print $2}' > $sample.rckeep.ids

grep -f $sample.rckeep.ids $sample.1.rev.fastq -A3 --no-group-separator > $sample.1.rev.keep.fastq
grep -f $sample.rckeep.ids $sample.2.fastq -A3 --no-group-separator > $sample.2.keep.fastq



FW="$(wc -l $sample.1.ids | cut -d' ' -f1)"
REV="$(wc -l $sample.2.rev.ids | cut -d' ' -f1)"
FWrc="$(wc -l $sample.1.rev.ids | cut -d' ' -f1)"
REVrc="$(wc -l $sample.2.ids | cut -d' ' -f1)"
KEPT="$(wc -l $sample.keep.ids | cut -d' ' -f1)"
KEPTrc="$(wc -l $sample.rckeep.ids | cut -d' ' -f1)"

PROP_KEPT="$(( (100*$KEPT*2) / ($FW+$REV) ))"
PROP_KEPTrc="$(( (100*$KEPTrc*2) / ($FWrc+$REVrc) ))"

echo "...kept $KEPT out of $FW FW & $REV REV reads ($PROP_KEPT %)"
echo "...kept $KEPTrc out of $FWrc FW & $REVrc REV reverse complement reads ($PROP_KEPTrc %)"

rm $sample.1*.ids -f
rm $sample.2*.ids -f

