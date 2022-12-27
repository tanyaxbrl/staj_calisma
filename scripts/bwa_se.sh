#!/bin/bash
# kullanmak icin conda activate cutadapt

mkdir -p results
mkdir -p results/aligment
SRR=$1
END=$2
FASTA=$3

RAW_OUT=data/raw
REF_FOLDER=data/ref/


bwa aln -t 4 \
	${REF_FOLDER}/${FASTA} \
	data/processed/${END}/${SRR}.fastq.gz > results/aligment/${END}/${SRR}_p.sai
	
bwa sampe ${REF_FOLDER}/${FASTA} \
	results/aligment/${END}/${SRR}_p.sai \
	data/processed/${END}/${SRR}.fastq.gz > results/aligment/${END}/${SRR}.sam
