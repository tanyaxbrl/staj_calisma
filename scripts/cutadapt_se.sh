#!/bin/bash

SRR=SRR649944
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
	-o data/processed/${SRR}.fastq.gz \
	data/raw/${SRR}.fastq

