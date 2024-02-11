#!/bin/bash

while read LINE
do
	SRR=$(echo "$LINE" | cut -d " " -f1)
	END=$(echo "$LINE" | cut -d " " -f2)

# 	sra-tools conda ile hata veriyor, o yuzden bu kismi yapmayalim artik
#	./scripts/download_fastq.sh ${SRR} ${END}

	if [[ "${END}" == "pe" ]]
	then
		fastqc data/raw/${END}/${SRR}_1.fastq.gz data/raw/${END}/${SRR}_2.fastq.gz
	else
		fastqc data/raw/${END}/${SRR}.fastq.gz
	fi

done < $1
