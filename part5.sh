#!/bin/bash

TOOL=$2

while read LINE
do
        SRR=$(echo "$LINE" | cut -d " " -f1)
        END=$(echo "$LINE" | cut -d " " -f2)

        if [ ${END} == "pe" ]
        then
		featureCounts -p -T4 -t CDS -a data/ref/GCA_000007565.2_ASM756v2_genomic.gtf -o results/counts/counts-${SRR}-${TOOL}.txt results/alignment/${TOOL}/${SRR}.sorted.bam
        else
		featureCounts -T4 -t CDS -a data/ref/GCA_000007565.2_ASM756v2_genomic.gtf -o results/counts/counts-${SRR}-${TOOL}.txt results/alignment/${TOOL}/${SRR}.sorted.bam
        fi

done < $1
