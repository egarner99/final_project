#!/bin/bash
#SBATCH --account=PAS2880
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-downloads-%j.out
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=8

set -euo pipefail

fastq=$1
outdir=$2

TRIMGALORE=oras://community.wave.seqera.io/library/trim-galore:0.6.10--bc38c9238980c80e

# Initial logging

echo "Starting script run_fastqc.sh"
date

# Making the output dir

mkdir -p "$outdir"

# Loading & Running TrimGalore 

apptainer exec "$TRIMGALORE" trim_galore --2colour 20 --output_dir "$outdir" "$fastq"

# Final logging
echo 
echo "Finished script run_fastqc.sh"
fastqc --version
date
