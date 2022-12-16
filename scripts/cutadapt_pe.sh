#!/bin/bash
# kullanmak icin once conda activate cutadapt yaz
# calistirmak icin ./scripts/rnaseq.sh yaz 

SRR=${1}
END=${2}

ADAPTER1=AGATCGGAAGAG
ADAPTER2=AGATCGGAAGAG
THREADS=4
Q1=20
Q2=20
MIN_LEN=10

mkdir -p data/processed

#conda activate cutadapt

cutadapt -q ${Q1} \
	-m ${MIN_LEN} --trim-n \
	-Z -j ${THREADS} \
	-a ${ADAPTER1} -A ${ADAPTER2} \
	-o data/processed/${END}/${SRR}_1.fastq.gz \
	-p data/processed/${END}/${SRR}_2.fastq.gz \
	data/raw/${END}/${SRR}_1.fastq data/raw/${END}/${SRR}_2.fastq

