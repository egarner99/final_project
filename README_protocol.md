# Sequencing of soybean genotype 137 

- Author: Elisabeth Garner
- Date: Made on Oct. 31, 2025, last modified on...
- Working Dir: /fs/ess/PAS2880/users/egarner99/final_project
- Environment: Pitzer 


# Set-up of dirs:

```bash
mkdir final_project
```

Navigate to the `final_project` dir: 
```bash
cd final_project
```

The scripts dir for the downloads scripts & README.md files were made using the create new ile/folder options in VS code. However, they can also be created using the following if needed:

```bash
mkdir scripts
touch README_notebook.md
touch README_protocol.md
```

# Downloading the data from the SRA Explorer: 

The neccessary scripts/files can be found in the `downloading_files` dir. The script, `download_data.sh`, uses `sra_files.txt` to assign the first variable as the file, and second as the name the file will be saved to. It will also create a downloads dir for the files. It can be run as a job through the following:

```bash
sbatch scripts/download_data.sh sra_files.txt
```

After the script runs, the downloaded files and slurm file were moved into a dir called `GM137_data`, and can be referred to for the rest of the steps. A copy of the files was also made if needed.


# Running the GM137 files through FastQC:

A new dir for this section was created called `fastqc/`. 

To run the GM137 files through FastQC, the script `run_fastqc.sh` can be used, which is found in the `fastqc/` dir. It can be run using the following: 

```bash
for fastq in ../final_project/GM137_data/downloads/SRR*fastq.gz; do
  sbatch fastqc/run_fastqc.sh "$fastq" fastqc/results
done
```

As the script runs, it will create a dir in the `fastqc/` dir called `results` in which all the files can be found, if the `fastqc/results/` dir isn't already present. 


# Running the GM137 files through TrimGalore: 

A new dir for this section was created called `trimgalore/`, and can be created using the following in the terminal: 

```bash
mkdir trimgalore/
```

The GM137 files can be run through TrimGalore as paired end files using the script `run_trimgalore.sh`, which is found in the `trimgalore/` dir. It will also run FastQC once it is done trimming the files. It can be run using the following loop: 

```bash
for Seq_1 in ../final_project/GM137_data/downloads/SRR*-Seq_1.fastq.gz; do
    Seq_2=${Seq_1/-Seq_1/-Seq_2}
    sbatch trimgalore/run_trimgalore.sh "$Seq_1" "$Seq_2" trimgalore/results
done
```
As the script runs, it will again create a dir in `trimgalore/` called `results` in which the files can be found, if the `trimgalore/results` dir isn't already created. 




