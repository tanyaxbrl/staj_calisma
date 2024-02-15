#!/bin/bash

mkdir -p results/alignment/bowtie2

REFERENCE=GCA_009858895.3.fasta.gz
THREADS=4

bowtie2-build data/ref/${REFERENCE} data/ref/${REFERENCE}

while read LINE
do 
        SRR=$(echo "$LINE" | cut -d " " -f1)
        END=$(echo "$LINE" | cut -d " " -f2)

        if [[ ${END} == "pe" ]]
        then 
            ./scripts/bowtie_pe.sh ${SRR} ${END} ${REFERENCE}
        else 
            ./scripts/bowtie_se.sh ${SRR} ${END} ${REFERENCE}
        fi

done < $1

