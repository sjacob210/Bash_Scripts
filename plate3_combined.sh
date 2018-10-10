#!/bin/bash
#SBATCH --partition=cpu_long

sbatch --partition=cpu_medium --wait /gpfs/scratch/sj1879/REDUX/Scripts/FastQC_Scripts/Find_Texts_For_FQC.sh /gpfs/scratch/sj1879/REDUX/Manifests/Plate3_Merged/
/gpfs/scratch/sj1879/REDUX/Scripts/GeneralScripts/Change_Auth.sh
sbatch --partition=cpu_medium  /gpfs/scratch/sj1879/REDUX/Scripts/FastQC_Scripts/Loop_FastQC_MultiQC.sh /gpfs/scratch/sj1879/REDUX/Manifests/Plate3_Merged/FASTQC/



