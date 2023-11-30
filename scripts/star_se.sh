#!/bin/bash
# kullanmak icin conda activate rnaseq


SRR=$1
END=$2
FASTA=$3
THREADS=4

REF_FOLDER=data/ref/

STAR --runThreadN ${THREADS} \
	--genomeDir ${REF_FOLDER}/GenomeDir/ \
	--readFilesIn \
    results/processed/${END}/${SRR}.fastq.gz \
	--outFileNamePrefix results/alignment/star/${SRR}- \
	--readFilesCommand zcat

samtools view -q30 -F4 -Sb results/alignment/star/${SRR}-Aligned.out.sam > results/alignment/star/${SRR}.bam

samtools sort results/alignment/star/${SRR}.bam -o results/alignment/star/${SRR}.sorted.bam

samtools index results/alignment/star/${SRR}.sorted.bam

rm results/alignment/star/${SRR}-Aligned.out.sam
