# Sequencing of soybean genotype 137 

- Author: Elisabeth Garner
- Date: Made on Oct. 31, 2025, last modified on...
- Working Dir: /fs/ess/PAS2880/users/egarner99/final_project
- Environment: Pitzer 


# Set-up of dirs:

If needed, the project dir can be created using the following: 

```bash
mkdir final_project
```

Navigate to the `final_project` dir, it will be the workspace for the following steps: 

```bash
cd final_project
```

The dirs for scripts, results, and data, as well as the notebook and protocol files can be created using the "create new file/folder" options in VS code or using the following code:

```bash
mkdir scripts/
mkdir results/
mkdir data/
touch README_notebook.md
touch README_protocol.md
```

# Downloading the data from the SRA Explorer: 

Create a dir for the downloaded files: 

```bash
mkdir data/GM137_data
```

The GM137 files can be downloaded from the SRA Explorer using the `run_data_download.sh` script found in the `scripts/` dir. It will download the files, move them into a dir called `GM137_data/` in the `data/` dir, and will copy them as well into a dir called `GM137_data_copy/`, in the same location. It can be run using the following:

```bash
sbatch scripts/run_data_download.sh
```

The slurm file can be moved and stored using the following:

```bash
mkdir data/GM137_data/slurms/
mv slurm*.out data/GM137_data/slurms/
```

# Running the GM137 files through FastQC:

To run the GM137 files through FastQC, the script `run_fastqc.sh` can be used, which is found in the `scripts/` dir. It can be run using the following: 

```bash
for fastq in ../final_project/data/GM137_data/SRR*fastq.gz; do
  sbatch scripts/run_fastqc.sh "$fastq" results/fastqc
done
```

As the script runs, it will create a dir in the `results/` dir called `fastqc/` in which all the files can be found.


The slurm files can be moved and stored using the following:

```bash
mkdir results/fastqc/slurms/
mv slurm*.out results/fastqc/slurms/
```

# Running the GM137 files through TrimGalore: 

The GM137 files can be run through TrimGalore as paired end files using the script `run_trimgalore.sh`, which is found in the `scripts/` dir. It will also run FastQC once it is done trimming the files. It can be run using the following loop: 

```bash
for Seq_1 in ../final_project/data/GM137_data/SRR*-Seq_1.fastq.gz; do
    Seq_2=${Seq_1/-Seq_1/-Seq_2}
    sbatch scripts/run_trimgalore.sh "$Seq_1" "$Seq_2" results/trimgalore
done
```
As the script runs, it will again create a dir in `results/` called `trimgalore/` in which the files can be found.

The slurm files can be moved and stored using the following:

```bash
mkdir results/trimgalore/slurms/
mv slurm*.out results/trimgalore/slurms/
```

# Creating the reference genome index with Star: 


The reference genome can be found and downloaded on NCBI for Williams 82 soybean, GCF_000004515.6 (see README_notebook.md for further details). A new dir can be created to move the new files into using: 

```bash
mkdir data/GCF_Williams82_data/
```

The app FileZilla can be used to move the .fasta and .gtf files into VS Code to the `data/GCF_Williams82_data/` dir. The files are downloaded to your computer as a dir called `ncbi_dataset/`. In FileZilla, follow the structure of the `ncbi_dataset/` dir to the `GCF_000004515.6/` dir, and transfer over the .fna and .gtf file. The README file can also be transferred over as well if needed. The files can also be made executable by the following: 

```bash
chmod -R a+x data/GCF_Williams82_data
```

The script for creating the index is `run_star_index.sh` in the `script/` dir. It uses the .gtf file to map out the genes found on the GCF_000004515.6 genome, and will create a `results/star` dir if not already created. It can be run using the following: 

```bash
sbatch scripts/run_star_index.sh data/GCF_Williams82_data/GCF_000004515.6_Glycine_max_v4.0_genomic.fna data/GCF_Williams82_data/genomic.gtf results/star/index/
```

The slurm files can be moved and stored using the following:

```bash
mkdir results/star/slurms/
mv slurm*.out results/star/slurms/
```

# Aligning the GM137 reads to the reference genome index with Star: 

The script for aligning the GM137 sequences to the index is in `run_star_align.sh` in the `scripts/` dir. It takes the paired, trimmed sequences and maps them to the index created. It can be run with the following: 

```bash
for Seq_1 in ../final_project/results/trimgalore/SRR*-Seq_1_val_1.fq.gz; do
    Seq_2=${Seq_1/-Seq_1_val_1/-Seq_2_val_2}
    sbatch scripts/run_star_align.sh "$Seq_1" "$Seq_2" results/star/index/ data/GCF_Williams82_data/genomic.gtf results/star/align/
done
```

The slurm files can be moved and stored using the following: 

```bash
mkdir results/star/slurms/
mv slurm*.out results/star/slurms/
```

# Getting read count summary with featureCounts: 

The script for running featureCounts is in the `run_featurecounts.sh` in the `scripts/` dir. It takes the .gtf file and the BAM files from STAR to create a summary of the counts, which can be input into R Studio. It can be run with the following:

```bash
sbatch scripts/run_featurecounts.sh data/GCF_Williams82_data/genomic.gtf results/featurecounts/
```
The slurm files can be moved and stored using the following: 

```bash
mkdir results/featurecounts/slurms/
mv slurm*.out results/featurecounts/slurms
```

# Getting STAR and featureCounts output summary with MultiQC:

The script for running MultiQC is in the `scripts/` dir called `run_multiqc.sh`. It will create a summary of the outputs and information obtained from aligning the sequences with STAR and running featureCounts. It can be run with the following: 

```bash
sbatch scripts/run_multiqc.sh results/star/align/ results/featurecounts/ results/multiqc/
```

The slurm files can be moved and stored using the following:

```bash
mkdir results/multiqc/slurms/
mv slurm*.out results/multiqc/slurms/
```


