#!/bin/bash
#SBATCH --nodes=1
#SBATCH --partition=cpu_medium
#SBATCH --time=15:00:00

# COMPLETE PIPELINE FOR FASTQC AND MULTIQC


# create manifest directory at top level
srun /gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/Loop_Find_Fastqs.sh $1

# change the directory to 777
/gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/Change_Auth.sh $1
wait

# run the FastQC pipeline
sbatch --wait --partition=cpu_medium /gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/Loop_Submit_FastQC_pipeline.sh $1

#change auth
srun /gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/Change_Auth.sh $1
wait

#run multiqc
sbatch --wait --partition=cpu_medium /gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/loop_Multiqc.sh $1
wait


#run multiqc agg and graph pipeline
sbatch $1/Multiqc_Pipeline.sh $1

# generate the MultiQC aggregated results
#module load python/cpu/2.7.15
#python Find_MultiQC_and_Agg.py $1/Manifests/

#/gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/Change_Auth.sh $1

#generate report 
#python MultiQC_generic.py $1/Manifests/MULTIQC_AGGREGATED_RESULTS.csv

#/gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/Change_Auth.sh $1

#clear slurm output
rm -f $1/slurm*.out



