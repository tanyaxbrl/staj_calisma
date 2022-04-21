#!/bin/bash

SRR=$1

fastqc data/raw/${SRR}_1.fastq data/raw/${SRR}_2.fastq

