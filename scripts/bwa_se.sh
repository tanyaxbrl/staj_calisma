#!/bin/bash
# kullanmak icin conda activate cutadapt

SRR=$1
END=$2
FASTA=$3

RAW_OUT=data/raw
REF_FOLDER=data/ref/

bwa aln -t 4 \
	${REF_FOLDER}/${FASTA} \
	results/processed/${END}/${SRR}.fastq.gz > results/alignment/bwa/${SRR}_p.sai
	
bwa samse ${REF_FOLDER}/${FASTA} \
	results/alignment/bwa/${SRR}_p.sai \
	results/processed/${END}/${SRR}.fastq.gz | samtools view -F4 -q30 -Sb > results/alignment/bwa/${SRR}.bam

samtools sort results/alignment/bwa/${SRR}.bam -o results/alignment/bwa/${SRR}.sorted.bam

samtools index results/alignment/bwa/${SRR}.sorted.bam

rm results/aligment/bwa/${SRR}_p.sai
