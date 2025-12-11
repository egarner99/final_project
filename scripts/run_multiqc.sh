#!/bin/bash
#SBATCH --account=PAS2880
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-downloads-%j.out
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=8

set -euo pipefail

Star_files=$1
FeatureCounts_files=$2
outdir=$3

MultiQC=oras://community.wave.seqera.io/library/multiqc:1.33--e3576ddf588fa00d

# Initial logging

echo "Starting script run_multiqc.sh"
date

# Making the output dir

mkdir -p "$outdir"

# Running MultiQC

```bash
apptainer exec "$MultiQC" multiqc \
    --outdir "$outdir" \
    --template original \
    --title "Star and FeatureCounts Summary" \
    --ignore data/star/slurms/ \
    --ignore data/featurecounts/slurms/ \
    "$Star_files" \
    "$FeatureCounts_files"
```

# Final logging

echo 
echo "Finished script run_multiqc.sh"
echo Version:
apptainer exec "$MultiQC" multiqc --version
date
