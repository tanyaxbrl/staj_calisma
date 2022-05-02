#!/bin/bash

while read LINE
do 
        SRR=$(echo "LINE" | cut -f1)
        END=$(echo "LINE" | cut -f2)

        if [ ${END} == "PE"
        then 
            ./scripts/bwa.sh ${SRR}
        else 
            ./scripts/bwa_se.sh ${SRR} 
        fi

done < data.txt

