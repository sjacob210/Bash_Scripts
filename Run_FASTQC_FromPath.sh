#!/bin/bash
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=5:00:00
#SBATCH --job-name=FASTQC

module add fastqc/0.11.7

/gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/Change_Auth.sh

while IFS='' read -r R1_file && IFS= read -r R2_file <&3;do 
	sbatch --nodes=1 --partition=cpu_medium RunFASTQC.sh $R1_file $3 
	sbatch --nodes=1 --partition=cpu_medium RunFASTQC.sh $R2_file $3
	wait
done < $1 3< $2
