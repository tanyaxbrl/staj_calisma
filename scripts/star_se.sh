#!/bin/bash
# kullanmak icin conda activate rnaseq

mkdir -p results/star

SRR=$1
END=$2
FASTA=$3
THREADS=4

REF_FOLDER=data/ref/

STAR --runThreadN ${THREADS} \
	--genomeDir ${REF_FOLDER}/GenomeDir/ \
	--readFilesIn \
    data/processed/${END}/${SRR}.fastq.gz \
	--outFileNamePrefix results/star/${END}/${SRR}/${SRR}- \
	--readFilesCommand zcat

samtools view -q30 -F4 -Sb results/star/${END}/${SRR}/${SRR}-Aligned.out.sam > results/star/${END}/${SRR}/${SRR}.bam

samtools sort results/star/${END}/${SRR}/${SRR}.bam -o results/star/${END}/${SRR}/${SRR}.sorted.bam

samtools index results/star/${END}/${SRR}/${SRR}.sorted.bam
