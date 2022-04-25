#!/bin/bash
# kullanmak icin conda activate cutadapt

SRR=ERR3473047

RAW_OUT=data/raw

PROCESSED_OUT=data/processed

FASTA=E_coli.fna

bwa aln -t 4 \
	${RAW_OUT}/${FASTA} \
	${PROCESSED_OUT}/${SRR}_1.fastq.gz > ${RAW_OUT}/${SRR}_1_p.sai
	
bwa aln -t 4 \
	${RAW_OUT}/${FASTA} \
	${PROCESSED_OUT}/${SRR}_2.fastq.gz > ${RAW_OUT}/${SRR}_2_p.sai

bwa sampe ${RAW_OUT}/${FASTA} \
	${RAW_OUT}/${SRR}_1_p.sai \
	${RAW_OUT}/${SRR}_2_p.sai \
	${PROCESSED_OUT}/${SRR}_1.fastq.gz \
	${PROCESSED_OUT}/${SRR}_2.fastq.gz > results/${SRR}.sam
