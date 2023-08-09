#!/bin/bash

mkdir -p results/alignment/pe
mkdir -p results/alignment/se

REFERENCE=GCA_000007565.2_ASM756v2_genomic.fna

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

