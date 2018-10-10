#!/bin/bash

#mkdir $1/Manifests
for fol in $(find $1/Manifests/* -maxdepth 0 -name "P*"  -type d) ;do
    sbatch --partition=cpu_medium --wait $1/Scripts/Find_Texts_For_FQC.sh $fol
$1/Scripts/Change_Auth.sh $fol
sbatch --partition=cpu_medium  $1/Scripts/Loop_FastQC_MultiQC.sh $fol/FASTQC/
done
