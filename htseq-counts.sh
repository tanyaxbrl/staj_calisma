#!/bin/bash

#htseq_count [options] alignment_files gff_file 
#or
#phyton -m HTSeq.scripts.count [options] alignment_files gff_file




TOOL = $2

while read LINE
SRR = $(echo "$LINE" | cut -d " " -f1}
END = $(echo "$LINE" | cut -d " " -f2}

if [${END} == "pe"]
then
phyton -m HTSeq.scripts.count [-f sorted.bam -r ${SRR}_1 ${SRR}_2 -o results/counts/counts-${SRR}-${TOOL}_pe.txt] \ 
results/alignment/bowtie2/${TOOL}/${SRR}_pe.sorted.bam data/ref/*.gff

else
phyton -m HTSeq.scripts.count [-f sorted.bam -o results/counts/counts-${SRR}-${TOOL}_se.txt] \ 
results/alignment/bowtie2/${TOOL}/${SRR}_se.sorted.bam data/ref/*.gff  

fi
done < $1
