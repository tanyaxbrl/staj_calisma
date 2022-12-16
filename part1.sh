#!/bin/bash

while read LINE
do
	SRR=$(echo "$LINE" | cut -d " " -f1)
	END=$(echo "$LINE" | cut -d " " -f2)

	./scripts/download_fastq.sh ${SRR} ${END}
	echo $END
	if [[ ${END} == "pe" ]]
	then
		echo "pe"
		./scripts/fastqc_pe.sh ${SRR} ${END}
	else
		echo "se"
		./scripts/fastqc_se.sh ${SRR} ${END}
	fi

done < data.txt 
