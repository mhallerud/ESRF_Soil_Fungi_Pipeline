#!/bin/bash
barcodes=$1
fastq=$2
dir=$3

while read sample index lib f_barcode r_barcode f_primer r_primer locus
do

SampleID=$(echo $sample"_LIB_"$lib"_FBAR_"$f_barcode"_RBAR_"$r_barcode"_LOCUS_"$locus)
	DIR=$(echo "LIB_"$lib)
	[ -d $DIR ] || mkdir $DIR

	#Make reverse complements of our primer sets
	f_primer_adj=$(echo $f_primer|sed 's/Y/[CT]/g'|sed 's/W/[AT]/g'| sed 's/R/[AG]/g'|sed 's/D/[AGT]/g'| sed 's/I/[CGAT]/g')
        r_primer_adj=$(echo $r_primer|sed 's/Y/[CT]/g'|sed 's/W/[AT]/g'| sed 's/R/[AG]/g'|sed 's/D/[AGT]/g'| sed 's/I/[CGAT]/g')

        f_search=$f_barcode$f_primer_adj
	rcf_search=$(echo $f_barcode$f_primer_adj|rev|tr ACGT[] TGCA][)
	r_search=$r_barcode$r_primer_adj
        rcr_search=$(echo $r_barcode$r_primer_adj|rev|tr ACGT[] TGCA][)



#for i in $2
#	do
#
		outf="$(echo "$DIR/$SampleID.$dir.fastq" | sed 's/\^M//')"
		outr="$(echo "$DIR/$SampleID.$dir.rev.fastq" | sed 's/\^M//')"
		grep -P '.*(?<='$f_search').*(?='$rcr_search').*' $fastq -B1 -A2 --no-group-separator >> $outf
		grep -P '.*(?<='$r_search').*(?='$rcf_search').*' $fastq -B1 -A2 --no-group-separator >> $outr
#
#		cat $DIR/$SampleID.fasta | fastx_collapser | obigrep --uppercase -v -I -1$ | obigrep --uppercase -v -I -2$ > $DIR/$SampleID.$3.clust.fasta

#	done


done < $barcodes
