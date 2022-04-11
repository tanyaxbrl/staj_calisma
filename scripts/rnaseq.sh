#!/bin/bash

SRR=SRR18156027

fasterq-dump ${SRR} \
    --progress \
    --skip-technical \
    --split-spot \
    --outdir data/raw/ 
