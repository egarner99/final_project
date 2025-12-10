#!/bin/bash
#SBATCH --account=PAS2880
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-downloads-%j.out
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=8

set -euo pipefail

Seq_1=$1
Seq_2=$2
index_dir=$3
gtf=$4
outdir=$5

STAR=oras://community.wave.seqera.io/library/star:2.7.11b--84fcc19fdfab53a4

# Basename for naming the files in the outdir

sample_id=$(basename "$Seq_1" -Seq_1_val_1.fq.gz)

# Initial logging

echo "Starting script run_star_align.sh"
date

# Making the output dir

mkdir -p "$outdir"

# Loading & Running STAR for the index

apptainer exec "$STAR" STAR \
    --readFilesIn "$Seq_1" "$Seq_2" \
    --genomeDir "$index_dir" \
    --runThreadN 8 \
    --sjdbGTFfile "$gtf" \
    --readFilesCommand zcat \
    --outFileNamePrefix "$outdir"/"$sample_id"_ \
    --outSAMtype BAM SortedByCoordinate \
    --alignIntronMin 20 \
    --alignIntronMax 500000 \

# Final logging
echo 
echo "Finished script run_star_align.sh"
apptainer exec "$STAR" STAR --version
date

