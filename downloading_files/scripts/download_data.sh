#!/bin/bash
#SBATCH --account=PAS2880
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-downloads-%j.out
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=8

set -euo pipefail


# Check if the input file exists
if [ $# -ne 1 ]; then
    echo "Usage: ./download_sra.sh input_file.txt"
    echo "The input file should contain lines in the format: URL,new_filename"
    exit 1
fi

input_file=$1

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input file $input_file not found!"
    exit 1
fi

# Create a downloads directory if it doesn't exist
mkdir -p downloads

# Read the input file line by line
while IFS=',' read -r url new_name || [ -n "$url" ]; do
    # Skip empty lines
    if [ -z "$url" ]; then
        continue
    fi
    
    echo "Downloading $new_name from $url"
    wget -q --show-progress "$url" -O "downloads/$new_name"
    
    if [ $? -eq 0 ]; then
        echo "Successfully downloaded and renamed to $new_name"
    else
        echo "Error downloading $url"
    fi
done < "$input_file"

echo "All downloads completed!"