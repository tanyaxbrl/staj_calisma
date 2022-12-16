#!/bin/bash
# kullanmak icin conda activate cutadapt

mkdir -p results

SRR=$1
END=$2
FASTA=$3

RAW_OUT=data/raw
REF_FOLDER=data/ref/



bwa aln -t 4 \
	${REF_FOLDER}/${FASTA} \
	data/processed/${END}/${SRR}_1.fastq.gz > results/aligment/${END}/${SRR}_1_p.sai
	
bwa aln -t 4 \
	${REF_FOLDER}/${FASTA} \
	data/processed/${END}/${SRR}_2.fastq.gz > results/aligment/${END}/${SRR}_2_p.sai

bwa sampe ${REF_FOLDER}/${FASTA} \
	results/aligment/${END}/${SRR}_1_p.sai \
	results/aligment/${END}/${SRR}_2_p.sai \
	data/processed/${END}/${SRR}_1.fastq.gz \
	data/processed/${END}/${SRR}_2.fastq.gz > results/aligment/${END}/${SRR}.sam
