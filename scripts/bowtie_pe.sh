#!/bin/bash
# kullanmak icin conda activate cutadapt

SRR=$1
END=$2
FASTA=$3

OUT=results/alignment/bowtie2

echo "aligning ${SRR}"

bowtie2-align-s -x data/ref/${FASTA} -p 4 -1 results/processed/${END}/${SRR}_1.fastq.gz -2 results/processed/${END}/${SRR}_2.fastq.gz |  samtools view -F4 -q30 -Sb > ${OUT}/${SRR}.bam

samtools sort ${OUT}/${SRR}.bam -o ${OUT}/${SRR}.sorted.bam

samtools index ${OUT}/${SRR}.sorted.bam

