#!/bin/bash

while read LINE
do
	SRR=$(echo "$LINE" | cut -f1)
	END=$(echo "$LINE" | cut -f2)

	./scripts/download_fastq.sh ${SRR}
	
	if [ ${END} == "PE" ]
	then
		./scripts/fastqc_pe.sh ${SRR}
	else
		./scripts/fastqc_se.sh ${SRR}
	fi

done < data.txt 
