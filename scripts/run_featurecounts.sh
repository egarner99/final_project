#!/bin/bash
#SBATCH --account=PAS2880
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-downloads-%j.out
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=8

set -euo pipefail
gtf=$1
outdir=$2

FeatureCounts=oras://community.wave.seqera.io/library/subread:2.1.1--bae420bffb4edf16

# Initial logging

echo "Starting script run_featurecounts.sh"
date

# Making the output dir

mkdir -p "$outdir"

# Running FeatureCounts

apptainer exec "$FeatureCounts" featureCounts \
    -p \
    -B \
    -C \
    -T 8 \
    -a "$gtf" \
    -o "$outdir"/"GM137_samples".tsv \
    results/star/align/SRR*_Aligned.sortedByCoord.out.bam

# Final logging

echo 
echo "Finished script run_featurecounts.sh"
echo Version:
apptainer exec "$FeatureCounts" featureCounts -v
date
