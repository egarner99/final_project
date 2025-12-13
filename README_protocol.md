# Sequencing of soybean genotype 137 

- Author: Elisabeth Garner
- Date: Made on Oct. 31, 2025, last modified on Dec. 12, 2025
- Working Dir: /fs/ess/PAS2880/users/egarner99/final_project
- Environment: Pitzer 

<br>

## Set-up of dirs:

If needed, the project dir can be created using the following: 

```bash
mkdir final_project
```

<br>

Navigate to the `final_project` dir, it will be the workspace for the following steps: 

```bash
cd final_project
```

<br>

The dirs for scripts, results, and data, as well as the README_notebook and README_protocol files were created using the "create new file/folder" options in VS code or through the terminal. Although the files currently found in the `data/` can be used, it along with the `results/` dir can be created using the following code:

```bash
mkdir results/
mkdir data/
```

<br>

## Downloading the data from the SRA Explorer: 

The `GM137_data/` files found in the `data/` can be used. However, if they need to be downloaded again, it can be done with the following steps. First, creating a dir for the downloaded files: 

```bash
mkdir data/GM137_data/
```
<br>

The GM137 files can be downloaded from the SRA Explorer using the `run_data_download.sh` script found in the `scripts/` dir. It will download the files, move them into a dir called `GM137_data/` in the `data/` dir, and will copy them as well into a dir called `GM137_data_copy/`, in the same location. It can be run using the following:

```bash
sbatch scripts/run_data_download.sh
```

<br>

The slurm file can be moved and stored using the following:

```bash
mkdir data/GM137_data/slurms/
mv slurm*.out data/GM137_data/slurms/
```

<br>

## Running the GM137 files through FastQC:

To run the GM137 files through FastQC, the script `run_fastqc.sh` can be used, which is found in the `scripts/` dir. It can be run using the following: 

```bash
for fastq in ../final_project/data/GM137_data/SRR*fastq.gz; do
  sbatch scripts/run_fastqc.sh "$fastq" results/fastqc
done
```

<br>

As the script runs, it will create a dir in the `results/` dir called `fastqc/` in which all the files can be found.

<br>

The slurm files can be moved and stored using the following:

```bash
mkdir results/fastqc/slurms/
mv slurm*.out results/fastqc/slurms/
```

<br>

## Running the GM137 files through TrimGalore: 

The GM137 files can be run through TrimGalore as paired end files using the script `run_trimgalore.sh`, which is found in the `scripts/` dir. It will also run FastQC once it is done trimming the files. It can be run using the following loop: 

```bash
for Seq_1 in ../final_project/data/GM137_data/SRR*-Seq_1.fastq.gz; do
    Seq_2=${Seq_1/-Seq_1/-Seq_2}
    sbatch scripts/run_trimgalore.sh "$Seq_1" "$Seq_2" results/trimgalore
done
```

<br>

As the script runs, it will again create a dir in `results/` called `trimgalore/` in which the files can be found.

<br>

The slurm files can be moved and stored using the following:

```bash
mkdir results/trimgalore/slurms/
mv slurm*.out results/trimgalore/slurms/
```

<br>

## Creating the reference genome index with Star: 



The `GCF_Williams82_data/` files found in the `data/` dir (if not re-made earlier) can be used. However, if needed to be downloaded, the reference genome can be found and downloaded on NCBI for Williams 82 soybean, GCF_000004515.6 (see README_notebook.md for the link to it on NCBI). A new dir can be created to move the new files into using: 

```bash
mkdir data/GCF_Williams82_data/
```

<br>

The app FileZilla can be used to move the .fasta and .gtf files into VS Code to the `data/GCF_Williams82_data/` dir. The files are downloaded to your computer as a dir called `ncbi_dataset/`. In FileZilla, follow the structure of the `ncbi_dataset/` dir to the `GCF_000004515.6/` dir, and transfer over the .fna and .gtf file. The README file can also be transferred over as well if needed. The files can also be made executable by the following: 

```bash
chmod -R a+x data/GCF_Williams82_data
```

<br>

The script for creating the index is `run_star_index.sh` in the `script/` dir. It uses the .gtf file to map out the genes found on the GCF_000004515.6 genome, and will create a `results/star/` dir if not already created. It can be run using the following: 

```bash
sbatch scripts/run_star_index.sh data/GCF_Williams82_data/GCF_000004515.6_Glycine_max_v4.0_genomic.fna data/GCF_Williams82_data/genomic.gtf results/star/index/
```

<br>

The slurm files can be moved and stored using the following:

```bash
mkdir results/star/slurms/
mv slurm*.out results/star/slurms/
```

<br>

## Aligning the GM137 reads to the reference genome index with Star: 

The script for aligning the GM137 sequences to the index is `run_star_align.sh` in the `scripts/` dir. It takes the paired, trimmed sequences and maps them to the index created. It can be run with the following: 

```bash
for Seq_1 in ../final_project/results/trimgalore/SRR*-Seq_1_val_1.fq.gz; do
    Seq_2=${Seq_1/-Seq_1_val_1/-Seq_2_val_2}
    sbatch scripts/run_star_align.sh "$Seq_1" "$Seq_2" results/star/index/ data/GCF_Williams82_data/genomic.gtf results/star/align/
done
```

<br>

The slurm files can be moved and stored using the following: 

```bash
mkdir results/star/slurms/
mv slurm*.out results/star/slurms/
```

<br>

## Getting read count summary with featureCounts: 

The script for running featureCounts is `run_featurecounts.sh` in the `scripts/` dir. It takes the .gtf file and the BAM files from STAR to create a summary of the counts, which can be input into R Studio. It can be run with the following:

```bash
sbatch scripts/run_featurecounts.sh data/GCF_Williams82_data/genomic.gtf results/featurecounts/
```

<br>

The slurm files can be moved and stored using the following: 

```bash
mkdir results/featurecounts/slurms/
mv slurm*.out results/featurecounts/slurms
```
<br>

## Getting STAR and featureCounts output summary with MultiQC:

The script for running MultiQC is in the `scripts/` dir called `run_multiqc.sh`. It will create a summary of the outputs and information obtained from aligning the sequences with STAR and running featureCounts. It can be run with the following: 

```bash
sbatch scripts/run_multiqc.sh results/star/align/ results/featurecounts/ results/multiqc/
```
<br>

The slurm files can be moved and stored using the following:

```bash
mkdir results/multiqc/slurms/
mv slurm*.out results/multiqc/slurms/
```

<br>

## Gene Expression Analysis in R Studio: 

In R Studio, the analyses can be run by using the `deseq2_steps.qmd` Quarto document in the `r_studio/` dir. It will run and create a PCA plot of all the treatments, Volcano plots for each treatment combination, and a boxplot for one of the most signficantly expressed genes, LOC100789313. If needed, the results tables for the combinations of each treatments (H. glycines race 2 vs H. glycines race 3, H. glycines race 2 vs noninfected, and H. glycines race 3 vs noninfected) can be found in the results dir, although they can be created and saved with the Quatro document. 


