#!/bin/bash

SRR=${1}
END=${2}

	trimmomatic PE -threads 4 data/raw/${END}/${SRR}_1.fastq.gz data/raw/${END}/${SRR}_2.fastq.gz results/processed/${END}/${SRR}_1.fastq.gz results/processed/${END}/${SRR}_unpaired_1.fastq.gz results/processed/${END}/${SRR}_2.fastq.gz results/processed/${END}/${SRR}_unpaired_2.fastq.gz MINLEN:30 LEADING:20 TRAILING:20

	fastqc results/processed/${END}/${SRR}_1.fastq.gz results/processed/${END}/${SRR}_2.fastq.gz

#alternatif : java -jar trimmomatic-0.39.jar PE data/raw/${END}/${SRR}_1.fastq.gz data/raw/${END}/${SRR}_2.fastq.gz results/processed/${END}/${SRR}_1_paired.fastq.gz results/processed/${END}/${SRR}_1_unpaired.fastq.gz results/processed/${END}/${SRR}_2_paired.fastq.gz results/processed/${END}/${SRR}_2_unpaired.fastq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 MINLEN:30

#java -jar trimmomatic-0.39.jar PE input_forward.fq.gz input_reverse.fq.gz \ 
#output_forward_paired.fq.gz output_forward_unpaired.fq.gz output_reverse_paired.fq.gz \ 
#output_reverse_unpaired.fq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 MINLEN:30

#ILLUMINACLIP adaptor removing
#LEADING and TRAILING removing low quality or N bases
#SLIDINGWINDOW 4 bazlik çerçeve kaydiriyor, baz kalitesi 15 alti olursa kesiyor ???
#MINLEN minimum uzunluk


