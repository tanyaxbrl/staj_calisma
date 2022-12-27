#!/bin/bash

mkdir -p results/aligment
SRR=$1
END=$2
FASTA=$3

REF_FOLDER=data/ref/

samtools view \
    -F12 -q30 -Sb results/aligment/${END}/${SRR}.bam

samtools sort \
    results/aligment/${END}/${SRR}.bam -o results/aligment/${END}/${SRR}.sorted.bam

samtools index \
    results/aligment/${END}/${SRR}.sorted.bam

bcftools mpileup \
    -Ov --fasta-ref ${REF_FOLDER}/${FASTA}
    results/${END}/${SRR}.sorted.bam 

bcftools call \
    -mv -Ov -o results/aligment/${END}/calls.vcf

    