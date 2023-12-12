

TOOL=$1
 
featureCounts -T4 -t CDS -a data/ref/GCA_000007565.2_ASM756v2_genomic.gtf -o results/counts/counts-${TOOL}.txt results/alignment/${TOOL}/*.sorted.bam

