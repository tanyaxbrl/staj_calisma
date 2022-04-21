#!/bin/bash

SRR=SRR7405881
SRA_OUT=data/SRA

prefetch ${SRR} -O ${SRA_OUT}

fasterq-dump \
	--progress \
	--split-3 \
	${SRA_OUT}/${SRR} \
	-O data/raw/ 

fastqc data/raw/${SRR}_1.fastq data/raw/${SRR}_2.fastq

