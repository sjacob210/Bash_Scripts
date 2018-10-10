#!/bin/bash
#SBATCH --partition=cpu_medium
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=5:00:00
#SBATCH --job-name=LoopThroughDir

#make sure Manifests subfolder is main
parentloc=/gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/Manifests/
#create directory if need be
if [ !  -d "$parentloc" ];then
	mkdir -p $parentloc
fi

/gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/Change_Auth.sh $parentloc


for fol in $(find $1/* -maxdepth 0 -name "P*"  -type d); do
	platename="${fol##*/}"
	/gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/Find_Mates_From_Dir.sh $fol $platename 
	/gpfs/data/proteomics/projects/TRASANDE_LAB/Meta_Data_Information/FASTQC/MERGEDFASTQS_2/Change_Auth.sh $parentloc
done
