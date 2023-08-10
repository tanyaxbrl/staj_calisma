#!/bin/bash
# kullanmak icin conda activate cutadapt

mkdir -p results/alignment/bowtie2

SRR=$1
END=$2
FASTA=$3

OUT=results/alignment/bowtie2

RAW_OUT=data/raw
REF_FOLDER=data/ref/

echo "aligning ${SRR}"

bowtie2-align-s -x data/ref/${FASTA} -p 4 -U data/processed/${END}/${SRR}.fastq.gz |  samtools view -F3 -q30 -Sb > ${OUT}/${SRR}.bam

samtools sort ${OUT}/${SRR}.bam -o ${OUT}/${SRR}.sorted.bam

samtools index ${OUT}/${SRR}.sorted.bam

