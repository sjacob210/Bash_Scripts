#!/bin/sh
#SBATCH --N=1 
#SBATCH --partition=cpu_medium    
#SBATCH --n=1      
#SBATCH --c=4         
#SBATCH --time=1:00:00  

# generate the MultiQC aggregated results
module load python/cpu/2.7.15

python $1/Find_MultiQC_and_Agg.py $1/Manifests/

srun --partition=cpu_short /gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/Change_Auth.sh $1

wait

#generate report 
python $1/MultiQC_generic.py $1/Manifests/MULTIQC_AGGREGATED_RESULTS.csv

wait

sbatch --partition=cpu_medium --mem=100GB /gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/Change_Auth.sh $1

