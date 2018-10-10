#!/bin/bash

#mkdir $1/Manifests
for fol in $(find $1/Manifests/* -maxdepth 0 -name "P*"  -type d) ;do
    sbatch --partition=cpu_medium --wait /gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/Find_Texts_For_FQC.sh $fol
/gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/Change_Auth.sh $fol
sbatch --partition=cpu_medium  /gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/Loop_FastQC_MultiQC.sh $fol/FASTQC/
done
