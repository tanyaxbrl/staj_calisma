#!/bin/bash

mkdir -p results/processed/se
mkdir -p results/processed/pe

while read LINE
do
	SRR=$(echo "$LINE" | cut -d " " -f1)
	END=$(echo "$LINE" | cut -d " " -f2)

	if [[ ${END} == "pe" ]]
	then
		echo "pe"
		./scripts/cutadapt_pe.sh ${SRR} ${END}
	else

		echo "se"
		echo ${SRR}
		echo ${END}
		./scripts/cutadapt_se.sh ${SRR} ${END}
	fi

done < data.txt 

