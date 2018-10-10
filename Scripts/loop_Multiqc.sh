#!/bin/bash

for fol in $(find $1/Manifests/P* -name "*FASTQC" -type d);do
	sbatch --partition=cpu_medium --wait /gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/run_multiqc.sh $fol
done
