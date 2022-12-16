#!/bin/bash

SRR=$1
END=$2

fastqc data/raw/${END}/${SRR}_1.fastq data/raw/${END}/${SRR}_2.fastq

