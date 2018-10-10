#!/bin/bash
#SBATCH --partition=cpu_medium
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=5:00:00
#SBATCH --job-name=LoopThroughDir

#make sure Manifests subfolder is main
parentloc=$1/Manifests/

#create directory if need be
if [ !  -d "$parentloc" ];then
	mkdir -p $parentloc
fi

# clear permissions
$1/Scripts/Change_Auth.sh $parentloc

# note the pseudo-regex P*
for fol in $(find $1/* -maxdepth 0 -name "P*"  -type d); do
	platename="${fol##*/}" # string manipulate to get the plate name
	$1/Scripts/Find_Mates_From_Dir.sh $fol $platename  # Find paired information
	$1/Scripts/Change_Auth.sh $parentloc # change permissions
done
