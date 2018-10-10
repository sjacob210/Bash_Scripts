#!/bin/bash
#SBATCH --partition=cpu_long
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=15:00:00
#SBATCH --job-name=RUNFQC

resultspath=$1/FASTQC/


mkdir -p $resultspath

$1/Scripts/Change_Auth.sh $resultspath

R1_pth="$(find $1 -name "*R1*.txt" -type f)"
R2_pth="$(find $1 -name "*R2*.txt" -type f)"

srun $1/Scripts/Run_FASTQC_FromPath.sh $R1_pth $R2_pth $resultspath
$1/Scripts/Change_Auth.sh $resultspath

