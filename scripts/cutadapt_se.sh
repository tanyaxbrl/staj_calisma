#!/bin/bash

SRR=${1}
END=${2}

ADAPTER1=AGATCGGAAGAG
ADAPTER2=AGATCGGAAGAG
THREADS=4
Q1=20
MIN_LEN=10

mkdir -p data/processed

#conda activate cutadapt

cutadapt -q ${Q1} \
	-m ${MIN_LEN} --trim-n \
	-Z -j ${THREADS} \
	-a ${ADAPTER1} \
	-o data/processed/${END}/${SRR}.fastq.gz \
	data/raw/${END}/${SRR}.fastq

