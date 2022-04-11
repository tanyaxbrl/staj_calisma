#!/bin/bash

SRR=ERR3473047

fasterq-dump ${SRR} \
    --progress \
    --skip-technical \
    --split-files \
    --outdir data/raw/ 
