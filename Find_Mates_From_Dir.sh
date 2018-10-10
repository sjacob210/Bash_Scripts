#!/bin/bash
#SBATCH --partition=cpu_short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=5:00:00
#SBATCH --job-name=Create_Manifest_R2

#create new plate path
outloc=$1/Manifests/$2



#create plate directory
if [ ! -d "$outloc" ];then
	mkdir -p $outloc
fi


# generic output for the location of files
man1=$2_Manifest_R1.txt
man2=$2_Manifest_R2.txt


# please input full paths
find $1 -type f -name "*R1*.gz" | sort -z > $outloc/$man1 
find $1 -type f -name "*R2*.gz" | sort -z > $outloc/$man2
