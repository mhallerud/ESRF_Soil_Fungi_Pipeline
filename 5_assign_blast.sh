#!/bin/bash
#FASTA=$1

#blastn -db nt -query $FASTA -outfmt "10 qseqid sseqid sscinames staxids pident qcovs evalue bitscore qseq sseq" -max_target_seqs 1 -max_hsps 20 -evalue 1e-5 -out $FASTA.blast.csv
blastn -db nt -query ESRF_seqtab_nochim_clusterotus_plates110.fasta -max_hsps 20 -evalue 1e-5 -outfmt "10 qseqid sseqid sscinames staxids pident qcovs evalue bitscore qseq sseq" -out ESRF_seqtab_nochim_clusterotus_plates110.blast.csv -remote
