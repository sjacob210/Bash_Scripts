#!/bin/bash

for fol in $(find $1/Manifests/P* -name "*FASTQC" -type d);do
	sbatch --partition=cpu_medium --wait $1/Scripts/run_multiqc.sh $fol
done
