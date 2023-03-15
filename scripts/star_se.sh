#!/bin/bash
# kullanmak icin conda activate rnaseq

mkdir -p results/star

SRR=$1
END=$2
FASTA=$3
THREADS=8

REF_FOLDER=data/ref/

STAR --runThreadN ${THREADS} \
	--genomeDir ${REF_FOLDER}/GenomeDir/ \
	--readFilesIn \
    data/processed/${END}/${SRR}.fastq.gz \
	--outFileNamePrefix results/star/${END}/${SRR} \
	--readFilesCommand zcat
