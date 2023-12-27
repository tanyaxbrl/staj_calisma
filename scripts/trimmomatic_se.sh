#!/bin/bash

SRR=${1}
END=${2}

	trimmomatic SE -threads 1 data/raw/${END}/${SRR}.fastq.gz results/processed/${END}/${SRR}.fastq.gz MINLEN:30 LEADING:20 TRAILING:20

	fastqc results/processed/${END}/${SRR}.fastq.gz

#alternafit : java -jar trimmomatic-0.35.jar SE -phred20 data/${END}/${SRR} results/processed/${END}/${SRR}_trimmed.fastq.gz ILLUMINACLIP:TruSeq3-SE:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:30



#java -jar trimmomatic-0.35.jar SE -phred20 input.fq.gz output.fq.gz ILLUMINACLIP:TruSeq3-SE:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:30
#input girdi dosyasi, output cikti dosyasi. inputlar oldugu gibi outputlara _trimmed eklenebilir 
#phred kalite belirtiliyor
#ILLUMINACLIP illumina spesifik adaptor
#SLIDINGWINDOW pencere kaydirarak trimliyor sanirim. penceredeki average wwuality belirtilenden azda atiyor
#LEADING okuma basinda kalite dusukse atiyor
#TRAILING okuma sonunda kalite dusukse atiyor
#MINLEN belirtilen uzunlugun altindaysa okumayi atiyor


