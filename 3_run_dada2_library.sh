#!/bin/bash
/local/cluster/micromamba/envs/R-4.3.1/activate.sh 

bash

## ARGUMENTS: 1 = path to library (e.g., LIB_ITSP1); 2 = prefix for outputs (e.g., ITSP1_cutadapt_) 
gunzip $1/cutadapt/*gz #unzip fq files 
Rscript dada2_plate.R $1 $2 #run dada2
gzip $1/cutadapt/*fastq #rezip fq files
