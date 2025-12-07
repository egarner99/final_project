#!/bin/bash
#SBATCH --account=PAS2880
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-downloads-%j.out
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=8

set -euo pipefail

Seq_1=$1
Seq_2=$2
outdir=$3

TRIMGALORE=oras://community.wave.seqera.io/library/trim-galore:0.6.10--bc38c9238980c80e

# Initial logging

echo "Starting script run_trimgalore.sh"
date

# Making the output dir

mkdir -p "$outdir"

# Loading & Running TrimGalore 

apptainer exec "$TRIMGALORE" trim_galore --paired --fastqc --2colour 20 --output_dir "$outdir" "$Seq_1" "$Seq_2"

# Final logging
echo 
echo "Finished script run_trimgalore.sh"
apptainer exec "$TRIMGALORE" trim_galore --version
date
