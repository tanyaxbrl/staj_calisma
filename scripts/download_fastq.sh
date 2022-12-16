#!/bin/bash

SRR=$1
END=$2

SRA_OUT=data/sra
FASTQ_OUT=data/raw/${END}

prefetch ${SRR} -O ${SRA_OUT}

fasterq-dump ${SRA_OUT}/${SRR} -O ${FASTQ_OUT}

