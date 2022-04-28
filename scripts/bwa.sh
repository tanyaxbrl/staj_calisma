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
	${PROCESSED_OUT}/${SRR}_1.fastq > results/${SRR}_1_p.sai
	
bwa aln -t 4 \
	${REF_FOLDER}/${FASTA} \
	${PROCESSED_OUT}/${SRR}_2.fastq > results/${SRR}_2_p.sai

bwa sampe ${REF_FOLDER}/${FASTA} \
	results/${SRR}_1_p.sai \
	results/${SRR}_2_p.sai \
	${PROCESSED_OUT}/${SRR}_1.fastq \
	${PROCESSED_OUT}/${SRR}_2.fastq > results/${SRR}.sam
