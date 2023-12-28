#!/bin/bash

mkdir -p results/counts/

#
#htseq_count [options] alignment_files gff_file or phyton -m HTSeq.scripts.count [options] alignment_files gff_file
TOOL=$2

while read LINE
do
	SRR=$(echo "$LINE" | cut -d " " -f1)
	END=$(echo "$LINE" | cut -d " " -f2)

	if [ ${END} == "pe" ]
	then
		htseq-count results/alignment/${TOOL}/${SRR}.sorted.bam data/ref/GCA_000007565.2_ASM756v2_genomic.gtf -n 4 -t gene > results/counts/counts-${SRR}-${TOOL}.txt
	#phyton -m HTSeq.scripts.count -r -c results/counts/counts-${SRR}-${TOOL}_pe.txt results/alignment/bowtie2/${TOOL}/${SRR}.bam data/ref/GCA_000007565.2_ASM756v2_genomic.gtf
	else
		htseq-count results/alignment/${TOOL}/${SRR}.sorted.bam data/ref/GCA_000007565.2_ASM756v2_genomic.gtf -n 4 -t gene > results/counts/counts-${SRR}-${TOOL}.txt
	#phyton -m HTSeq.scripts.count -c results/counts/counts-${SRR}-${TOOL}_se.txt results/alignment/bowtie2/${TOOL}/${SRR}.bam data/ref/GCA_000007565.2_ASM756v2_genomic.gtf
fi

done < $1
