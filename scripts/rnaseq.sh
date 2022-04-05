#!/bin/bash

SRR=SRR18156027

~/Software/sratoolkit.3.0.0-ubuntu64/bin/fasterq-dump ${SRR} \
    --progress \
    --skip-technical \
    --split-files \
    --outdir data/raw/