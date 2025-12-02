# Sequencing of soybean genotype 137 

- Author: Elisabeth Garner
- Date: Made on Oct. 31, 2025, last modified on...
- Working Dir: /fs/ess/PAS2880/users/egarner99/final_project
- Environment: Pitzer 

## Project Description: 



## 10/31/25: 

Set-up a few dirs for the project.

Created a script to download the data from the SRA explorer. Initially, it didn't want to run (kept getting an error that the script was empty), but reloading the page fixed the issue. I added the email option for END and FAIL, so it should hopefully inform me if it works or not. 

See the data_download.sh script and README_protocol.md for details. 

Had a couple of errors after trying the script with the header #!/bin/bash, attempting to run again with #!/usr/bin/env bash instead. 

<br>

## 11/5/25:

As mentioned, when trying the script a few times the download kept failing after a certain amount of files, with the following error appearing in the slurm files: 
```bash
(56) Recv failure: Connection reset by peer
```

I asked GitHub Copilot what the error could mean, and one of the suggestions was adding in a sleep command between each file like this: 
```bash
curl [URL1]
sleep 5
curl [URL2]
```

I tried it to see if it would work, but it still failed with the same error. Instead, I used a script suggested from GitHub Copilot; we were allowed to ask questions that we could use to help us for our project during Graded Assignment #5. The question I asked was: "How do I write a script to download and rename files from the SRA Explorer at the same time?" (from Graded Assignment #5). I copied the script from my initial promoting of the question, followed the process that the AI described (see README_protocol.md), and ran the script. 

Using the script worked! All the files (18 in total for R1 and R2) were downloaded, renamed, and put into a downloads folder (and the final logging statement was in the slurm file). The slurm file was also moved into the downloads dir as well. A copy of the downloads folder was made (`downloads_copy`) and both were put into a folder called `GM137_data`. For now, I also made both of the downloads dirs read only. 

The `scripts` dir with the downloading scripts and `sra_files.txt` were put in a dir called `downloading_files`. 

<br>

## 11/25/25: 

Today I tried to create a script as well as attempted to run it to put the GM137 files through the FastQC program. Recommended by Menuka, I am running it through FastQC before TrimGalore to get an idea of what the sequences look like (if there are multiple N's at the end, etc.). I used the examples in the class website/notes to base my script on. The script is called `run_fastqc.sh` and is the dir `fastqc/`, which I created. 

The first run didn't work, and kept repeating the initial logging statment. After looking back at the notes, I realized that the looping code is what is put in the terminal, not the script, and that this portion is what is needed in the script instead: 

```bash
fastqc --outdir "$fastq" "$outdir"
```

I then realized that I had put this section in the script in the wrong order, based on the slurm files that I had gotten and again the class website:

```bash
fastqc --outdir "$outdir" "$fastq"
```
I re-ran the script again to see if it would work, and it seemed to do so! The outputs were put into a dir called `fastqc/results/`, and the slurm files were moved in the `fastqc/` dir in another folder called `slurms`. 

Either tomorrow or Friday, I will check each of the .html files, and use the information to create a script to run the files through TrimGalore. The whole fastqc/ dir was moved into `.gitignore`.

For now, I kept the slurms for the runs that did not work from today, for reference later. It is called `old_slurms`, and is also in the `fastqc/` dir. 

<br>

## 11/28/25: 

Checking the .html files, they all seem to have good per base sequence quality, although some of them seem to have an error in the per tile sequence quality, as well as errors in per base sequence content and sequence duplication levels. I will have to do some research to see if those are an issue, and if that means I need to add something to my trimgalore script. 

I also worked on the trimgalore script for the GM137 files, using the class website and the fastq script I made to help me create it and know what to include. Initially, I had trouble getting the correct code to download the container, but with help from GitHub Copilot I figured out that I needed to use the command `trim_galore` instead of `trimgalore` at the end. Checking the .html files, I also saw that some of them had polyG's at the end, so I added the 2color option as well. After a bit of trial and error, I ran a trial run on a sequence that had the polyG's, with my script (`trimgalore/run_trimgalore`), using the command: 

```bash
sbatch trimgalore/run_trimgalore.sh GM137_data/downloads/SRR24727832_GSM7426419_Gm137_H._glycines_Race_2_infected_RNA_bio_rep_1_Glycine_max_RNA-Seq_2.fastq.gz trimgalore/results
```

## 11/29/25: 

After a bit more editing, my trial as seen above was able to work. With that in mind, I ran a loop for all of the files using the following code: 

```bash
for fastq in ../final_project/GM137_data/downloads/SRR*.fastq.gz; do
    sbatch trimgalore/run_trimgalore.sh "$fastq" trimgalore/results
done
```

## 12/2/25: 

I edited my loop to run the files as paired ends, with the following code: 

```bash
for Seq_1 in ../final_project/GM137_data/downloads/SRR*-Seq_1.fastq.gz; do
    Seq_2=${Seq_1/-Seq_1/-Seq_2}
    sbatch trimgalore/run_trimgalore.sh "$Seq_1" "$Seq_2" trimgalore/results
done
```

I initially had () around the second line instead of {} and ran it, those files will be removed once it is done since the loop was incorrect. 

I also changed my script to also run paired ends by adding `--paired` to the apptainer exec code, as well as changing `fastq=$1` to `Seq_1=$1` and `Seq_2=$2`. The `"$outdir"` was moved to `$3`. I also saw on the class website that a `--fastq` option can be added to automatically run FastQC again once the trimming is done, so I added that as well. I reran the files with these changes, and will check back later to see if it worked. 
