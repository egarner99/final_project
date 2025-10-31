#!/usr/bin/env bash
#SBATCH --account=PAS2880
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-downloads-%j.out
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=8

set -euo pipefail

# Initial logging
echo "Starting script data_download.sh"
date

# Downloading data from SRA website

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/034/SRR24727834/SRR24727834_1.fastq.gz -o SRR24727834_GSM7426417_Gm137_H._glycines_Race_3_infected_RNA_bio_rep_2_Glycine_max_RNA-Seq_1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/034/SRR24727834/SRR24727834_2.fastq.gz -o SRR24727834_GSM7426417_Gm137_H._glycines_Race_3_infected_RNA_bio_rep_2_Glycine_max_RNA-Seq_2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/033/SRR24727833/SRR24727833_1.fastq.gz -o SRR24727833_GSM7426418_Gm137_H._glycines_Race_3_infected_RNA_bio_rep_3_Glycine_max_RNA-Seq_1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/033/SRR24727833/SRR24727833_2.fastq.gz -o SRR24727833_GSM7426418_Gm137_H._glycines_Race_3_infected_RNA_bio_rep_3_Glycine_max_RNA-Seq_2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/035/SRR24727835/SRR24727835_1.fastq.gz -o SRR24727835_GSM7426416_Gm137_H._glycines_Race_3_infected_RNA_bio_rep_1_Glycine_max_RNA-Seq_1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/035/SRR24727835/SRR24727835_2.fastq.gz -o SRR24727835_GSM7426416_Gm137_H._glycines_Race_3_infected_RNA_bio_rep_1_Glycine_max_RNA-Seq_2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/032/SRR24727832/SRR24727832_1.fastq.gz -o SRR24727832_GSM7426419_Gm137_H._glycines_Race_2_infected_RNA_bio_rep_1_Glycine_max_RNA-Seq_1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/032/SRR24727832/SRR24727832_2.fastq.gz -o SRR24727832_GSM7426419_Gm137_H._glycines_Race_2_infected_RNA_bio_rep_1_Glycine_max_RNA-Seq_2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/031/SRR24727831/SRR24727831_1.fastq.gz -o SRR24727831_GSM7426420_Gm137_H._glycines_Race_2_infected_RNA_bio_rep_2_Glycine_max_RNA-Seq_1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/031/SRR24727831/SRR24727831_2.fastq.gz -o SRR24727831_GSM7426420_Gm137_H._glycines_Race_2_infected_RNA_bio_rep_2_Glycine_max_RNA-Seq_2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/030/SRR24727830/SRR24727830_1.fastq.gz -o SRR24727830_GSM7426421_Gm137_H._glycines_Race_2_infected_RNA_bio_rep_3_Glycine_max_RNA-Seq_1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/030/SRR24727830/SRR24727830_2.fastq.gz -o SRR24727830_GSM7426421_Gm137_H._glycines_Race_2_infected_RNA_bio_rep_3_Glycine_max_RNA-Seq_2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/027/SRR24727827/SRR24727827_1.fastq.gz -o SRR24727827_GSM7426424_Gm137_noninfected_RNA_bio_rep_3_Glycine_max_RNA-Seq_1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/027/SRR24727827/SRR24727827_2.fastq.gz -o SRR24727827_GSM7426424_Gm137_noninfected_RNA_bio_rep_3_Glycine_max_RNA-Seq_2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/029/SRR24727829/SRR24727829_1.fastq.gz -o SRR24727829_GSM7426422_Gm137_noninfected_RNA_bio_rep_1_Glycine_max_RNA-Seq_1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/029/SRR24727829/SRR24727829_2.fastq.gz -o SRR24727829_GSM7426422_Gm137_noninfected_RNA_bio_rep_1_Glycine_max_RNA-Seq_2.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/028/SRR24727828/SRR24727828_1.fastq.gz -o SRR24727828_GSM7426423_Gm137_noninfected_RNA_bio_rep_2_Glycine_max_RNA-Seq_1.fastq.gz
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR247/028/SRR24727828/SRR24727828_2.fastq.gz -o SRR24727828_GSM7426423_Gm137_noninfected_RNA_bio_rep_2_Glycine_max_RNA-Seq_2.fastq.gz

# Final logging
echo 
echo "Finished script data_download.sh"
date

