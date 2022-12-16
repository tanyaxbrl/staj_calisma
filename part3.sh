#!/bin/bash

mkdir -p results/aligment/pe
mkdir -p results/aligment/se

REFERENCE=GCF_000412675.1_ASM41267v1_genomic.fna

bwa index data/ref/${REFERENCE}

while read LINE
do 
        SRR=$(echo "$LINE" | cut -d " " -f1)
        END=$(echo "$LINE" | cut -d " " -f2)

        if [ ${END} == "pe" ]
        then 
            ./scripts/bwa_pe.sh ${SRR} ${END} ${REFERENCE}
        else 
            ./scripts/bwa_se.sh ${SRR} ${END} ${REFERENCE}
        fi

done < data.txt

