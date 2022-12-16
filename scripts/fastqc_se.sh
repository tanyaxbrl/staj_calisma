#!/bin/bash

SRR=${1}
END=${2}

fastqc data/raw/${END}/${SRR}.fastq


