#!/bin/bash

SRR=ERR3473047

fasterq-dump ${SRR} \
    --progress \
    --skip-technical \
    --split-files \
    --outdir data/raw/ 

fastqc data/raw/${SRR}_1.fastq data/raw/${SRR}_2.fastq

