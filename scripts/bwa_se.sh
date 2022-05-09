#!/bin/bash
# kullanmak icin conda activate cutadapt

mkdir -p results

SRR=$1

RAW_OUT=data/raw
REF_FOLDER=data/ref/

PROCESSED_OUT=data/processed

FASTA=GCF_000007565.2_ASM756v2_genomic.fna

bwa index data/ref/${FASTA}

bwa aln -t 4 \
	${REF_FOLDER}/${FASTA} \
	${PROCESSED_OUT}/${SRR}.fastq > results/${SRR}_p.sai
	
bwa sampe ${REF_FOLDER}/${FASTA} \
	results/${SRR}_p.sai \
	${PROCESSED_OUT}/${SRR}.fastq > results/${SRR}.sam
