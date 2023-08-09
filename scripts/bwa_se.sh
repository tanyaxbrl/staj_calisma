#!/bin/bash
# kullanmak icin conda activate cutadapt

mkdir -p results
mkdir -p results/alignment
SRR=$1
END=$2
FASTA=$3

RAW_OUT=data/raw
REF_FOLDER=data/ref/


bwa aln -t 4 \
	${REF_FOLDER}/${FASTA} \
	data/processed/${END}/${SRR}.fastq.gz > results/alignment/${END}/${SRR}_p.sai
	
bwa samse ${REF_FOLDER}/${FASTA} \
	results/alignment/${END}/${SRR}_p.sai \
	data/processed/${END}/${SRR}.fastq.gz | samtools view -F3 -q30 -Sb > results/alignment/${END}/${SRR}.bam

samtools sort results/alignment/${END}/${SRR}.bam -o results/alignment/${END}/${SRR}.sorted.bam

samtools index results/alignment/${END}/${SRR}.sorted.bam

