#!/bin/bash
#SBATCH --account=PAS2880
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-downloads-%j.out
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=16

set -euo pipefail

fasta=$1
gtf=$2
outdir=$3

STAR=oras://community.wave.seqera.io/library/star:2.7.11b--84fcc19fdfab53a4

# Initial logging

echo "Starting script run_star_index.sh"
date

# Making the output dir

mkdir -p "$outdir"

# Loading & Running STAR for the index

apptainer exec "$STAR" STAR \
    --runMode genomeGenerate \
     --genomeFastaFiles "$fasta" \
     --genomeDir "$outdir" \
     --sjdbGTFfile "$gtf" \
     --runThreadN 16 \
     --sjdbOverhang 149 \
     --genomeSAindexNbases 13

# Final logging
echo 
echo "Finished script run_star_index.sh"
apptainer exec "$STAR" STAR --version
date