#!/bin/bash

mkdir -p results/star/pe
mkdir -p results/star/se

REFERENCE=GCF_000412675.1_ASM41267v1_genomic.fna
THREADS=8

STAR --runMode genomeGenerate \
    --genomeDir data/ref/GenomeDir \
    --genomeFastaFiles data/ref/${REFERENCE} \
    --runThreadN ${THREADS}
        
while read LINE
do 
        SRR=$(echo "$LINE" | cut -d " " -f1)
        END=$(echo "$LINE" | cut -d " " -f2)

        if [ ${END} == "pe" ]
        then 
            ./scripts/star_pe.sh ${SRR} ${END} ${REFERENCE}
        else 
            ./scripts/star_se.sh ${SRR} ${END} ${REFERENCE}
        fi

done < data.txt

