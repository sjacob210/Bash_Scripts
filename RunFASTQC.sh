#!/bin/bash

module load fastqc/0.11.7

srun fastqc $1  --outdir=$2

