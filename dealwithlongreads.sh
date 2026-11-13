#!/bin/bash
raw=$1
outdir=$2
barcodes=$3

sample="$(basename $barcodes | sed 's/.txt//')"

# convert original fastq files to tables & merge
#seqkit fx2tab $raw > $raw.tsv
#seqkit fx2tab $raw2 > $raw2.tsv
#join -j 1 -o 1.1,1.2,1.3,2.3,1.5,2.5 <(sort -k1 $raw.tsv) <(sort -k1 $raw2.tsv) > $raw.assembled.tsv



# loop through each excluded read and handle...
while read sampleid lib_index lib f_barcode r_barcode f_primer r_primer locus;
do
	SampleID=$(echo $sample"_LIB_"$lib"_FBAR_"$f_barcode"_RBAR_"$r_barcode"_LOCUS_"$locus)	#make reverse complements of primer sets...
        f_primer_adj=$(echo $f_primer|sed 's/Y/[CT]/g'|sed 's/W/[AT]/g'| sed 's/R/[AG]/g'|sed 's/D/[AGT]/g'| sed 's/I/[CGAT]/g')
        r_primer_adj=$(echo $r_primer|sed 's/Y/[CT]/g'|sed 's/W/[AT]/g'| sed 's/R/[AG]/g'|sed 's/D/[AGT]/g'| sed 's/I/[CGAT]/g')

        f_search=$f_barcode$f_primer_adj
        rcf_search=$(echo $f_barcode$f_primer_adj|rev|tr ACGT[] TGCA][)
        r_search=$r_barcode$r_primer_adj
        rcr_search=$(echo $r_barcode$r_primer_adj|rev|tr ACGT[] TGCA][)

	# now search for these in files...
	while IFS=" " read -r id index fwseq revseq fwq revq; 
	do
		# set up...
		fwgrep="$(echo $fwseq | grep -P '(?<='$f_search').*' | wc -l)"
		revgrep="$(echo $revseq | grep -P '(?<='$r_search').*' | wc -l)"

		# check IF fwindex.fwprimer AND revindexrevprimer
		if [[ $fwgrep>0 ]] && [[ $revgrep>0 ]];
		then
		# add ID to .keep.ids
			echo $id >> "$outdir"/"$sample".longread.keep.ids
		fi;

		# check if RC rcf_search
		fwrcgrep="$(echo $fwseq | grep -P '(?<='$r_search').*' | wc -l)"
		revrcgrep="$(echo $revseq | grep -P '(?<='$f_search').*' | wc -l)"
		if [[ $fwrcgrep>0 ]] && [[ $revrcgrep>0 ]];
		then
			echo $id >> "$outdir"/"$sample".longread.rckeep.ids
		fi;

	done < $raw.unassembled.tsv
done < $barcodes


# copy these reads into the fastq file...
#keep="$(wc -l $outdir/$sample.longread.keep.ids | awk '{print $1}')"
if test -f $outdir/$sample.longread.keep.ids; then
	grep -f $outdir/$sample.longread.keep.ids $raw_R1_001.fastq -A3 --no-group-separator >> "$outdir"/"$SampleID".1.fastq;
	grep -f $outdir/$sample.longread.keep.ids $raw_R2_001.fastq -A3 --no-group-separator >> "$outdir"/"$SampleID".2.fastq;
fi

#keeprc="$(wc -l $outdir/$sample.longread.rckeep.ids | awk '{print $1}')"
if test -f $outdir/$sample.longread.rckeep.ids; then
	grep -f $outdir/$sample.longread.rckeep.ids "$raw"_R1_001.fastq -A3 --no-group-separator >> "$outdir"/"$SampleID".rev.1.fastq;
	grep -f $outdir/$sample.longread.rckeep.ids "$raw"_R2_001.fastq -A3 --no-group-separator >> "$outdir"/"$SampleID".rev.2.fastq;
fi


RECOV="$(wc -l $outdir/$sample.longread.keep.ids | cut -d' ' -f1)"
RECOVrc="$(wc -l $outdir/$sample.longread.rckeep.ids | cut -d' ' -f1)"

echo "...Recovered (( $RECOV+$RECOVrc )) reads"

# clean up...
#rm $outdir/$sample.longread*ids -f
