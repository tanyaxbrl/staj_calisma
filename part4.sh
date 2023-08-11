#!/bin/bash

mkdir -p results/alignment/star

REFERENCE=GCA_000007565.2_ASM756v2_genomic.fna
THREADS=4

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

