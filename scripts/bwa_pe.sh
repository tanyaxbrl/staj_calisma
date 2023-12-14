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
	results/processed/${END}/${SRR}_1.fastq.gz > results/alignment/bwa/${SRR}_1_p.sai
	
bwa aln -t 4 \
	${REF_FOLDER}/${FASTA} \
	results/processed/${END}/${SRR}_2.fastq.gz > results/alignment/bwa/${SRR}_2_p.sai

bwa sampe ${REF_FOLDER}/${FASTA} \
	results/alignment/bwa/${SRR}_1_p.sai \
	results/alignment/bwa/${SRR}_2_p.sai \
	results/processed/${END}/${SRR}_1.fastq.gz \
	results/processed/${END}/${SRR}_2.fastq.gz | samtools view -F2 -q30 -Sb > results/alignment/bwa/${SRR}.bam
	
samtools sort results/alignment/bwa/${SRR}.bam -o results/alignment/bwa/${SRR}.sorted.bam

samtools index results/alignment/bwa/${SRR}.sorted.bam

rm  results/alignment/bwa/${SRR}_1_p.sai results/alignment/bwa/${SRR}_2_p.sai
