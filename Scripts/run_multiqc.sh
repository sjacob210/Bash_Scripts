#!/bin/bash
#SBATCH --partition=cpu_medium
#SBATCH --nodes=1
#SBATCH --mem=100GB
#SBATCH --job-name=MultiQC

cd $1
module load python/cpu/2.7.15

mkdir -p $1/MultiQC

srun multiqc $1 --outdir $1/MultiQC

