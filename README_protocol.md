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
mv slurm* data/GM137_data/slurms/
```

# Running the GM137 files through FastQC:

To run the GM137 files through FastQC, the script `run_fastqc.sh` can be used, which is found in the `scripts/` dir. It can be run using the following: 

```bash
for fastq in ../final_project/data/GM137_data/downloads/SRR*fastq.gz; do
  sbatch scripts/run_fastqc.sh "$fastq" results/fastqc
done
```

As the script runs, it will create a dir in the `results/` dir called `fastqc/` in which all the files can be found.


# Running the GM137 files through TrimGalore: 

The GM137 files can be run through TrimGalore as paired end files using the script `run_trimgalore.sh`, which is found in the `scripts/` dir. It will also run FastQC once it is done trimming the files. It can be run using the following loop: 

```bash
for Seq_1 in ../final_project/data/GM137_data/downloads/SRR*-Seq_1.fastq.gz; do
    Seq_2=${Seq_1/-Seq_1/-Seq_2}
    sbatch scripts/run_trimgalore.sh "$Seq_1" "$Seq_2" results/trimgalore
done
```
As the script runs, it will again create a dir in `results/` called `trimgalore/` in which the files can be found.


# Creating the reference genome index with Star: 


The reference genome can be found on NCBI for Williams 82 soybean, GCF_000004515.6 (see README_notebook.md for further details). A new dir was created to move the new files into using: 

```bash
mkdir data/GCF_Williams82_data/
```

The app FileZilla was used to move the .fasta and .gtf files into VS Code to the `data/GCF_Williams82_data/` dir.

The script for creating the index is `run_star_index.sh` in the `script/` dir. It uses the .gtf file to map out the genes found on the GCF_000004515.6 genome, and will create a `results/star` dir if not already created. It can be run using the following: 

```bash
sbatch star/run_star_index.sh star/GCF_Williams82_data/ncbi_dataset/data/GCF_000004515.6/GCF_000004515.6_Glycine_max_v4.0_genomic.fna star/GCF_Williams82_data/ncbi_dataset/data/GCF_000004515.6/genomic.gtf results/star
```




