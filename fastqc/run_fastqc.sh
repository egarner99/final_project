#!/bin/bash
#SBATCH --account=PAS2880
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-downloads-%j.out
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=8

set -euo pipefail

# Initial logging
echo "Starting script run_fastqc.sh"
date

# Loading FastQC

module load fastqc/0.12.1

# Looping over the data files

for fastq in ../final_project/GM137_data/downloads/final_project/GM137_data/downloads/SRR*fastq.gz; do
  bash fastqc/run_fastqc.sh "$fastq" fastqc/results
done

# Final logging
echo 
echo "Finished script run_fastqc.sh"
fastqc --version
date
