#!/bin/bash

mkdir -p results/alignment/bwa/

REFERENCE=GCA_009858895.3.fasta.gz

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

done < $1

