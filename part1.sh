#!/bin/bash

while read LINE
do
	SRR=$(echo "$LINE" | cut -d " " -f1)
	END=$(echo "$LINE" | cut -d " " -f2)

# 	sra-tools conda ile hata veriyor, o yuzden bu kismi yapmayalim artik
#	./scripts/download_fastq.sh ${SRR} ${END}

	echo $END
	if [[ ${END} == "pe" ]]
	then
		echo "pe"
		fastqc data/raw/${END}/${SRR}_1.fastq data/raw/${END}/${SRR}_2.fastq
	else
		echo "se"
		fastqc data/raw/${END}/${SRR}.fastq
	fi

done < data.txt 
