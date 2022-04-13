#!/bin/bash
# kullanmak icin once conda activate cutadapt yaz
# calistirmak icin ./scripts/rnaseq.sh yaz 

SRR=ERR3473047
ADAPTER1=AGATCGGAAGAG
ADAPTER2=AGATCGGAAGAG
THREADS=4
Q1=20
Q2=20
MIN_LEN=10

mkdir -p data/processed

#conda activate cutadapt

cutadapt -q ${Q1} -Q ${Q2} \
	-m ${MIN_LEN} --trim-n \
	-Z -j ${THREADS} \
	-a ${ADAPTER1} -A ${ADAPTER2} \
	-o data/processed/${SRR}_1.fastq.gz \
	-p data/processed/${SRR}_2.fastq.gz \
	data/raw/${SRR}_1.fastq data/raw/${SRR}_2.fastq

fastqc data/processed/${SRR}_1.fastq.gz data/processed/${SRR}_2.fastq.gz
