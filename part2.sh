#!/bin/bash

mkdir -p data/processed
WD=$(pwd -P)

while read LINE
do
	SRR=$(echo "$LINE" | cut -f1)
        END=$(echo "$LINE" | cut -f2)
	CUT=$(echo "$LINE" | cut -f3)

	if [ ${CUT} == "YES" ]
	then
		echo "CUTADAPT CALISSIN"
	else
		if [ ${END} == "PE" ]
		then
			ln -s ${WD}/data/raw/${SRR}_1.fastq data/processed
			ln -s ${WD}/data/raw/${SRR}_2.fastq data/processed
		else
			ln -s ${WD}/data/raw/${SRR}.fastq data/processed
		fi
	fi

done < data.txt

while read LINE
do
        SRR=$(echo "$LINE" | cut -f1)
        END=$(echo "$LINE" | cut -f2)
        CUT=$(echo "$LINE" | cut -f3)

	if [ ${CUT} == "YES" ]
        then
		if [ ${END} == "PE" ]
                then
			./scripts/fastqc_pe.sh ${SRR}
                else

			./scripts/fastqc_se.sh ${SRR}
                fi
	fi
done < data.txt

