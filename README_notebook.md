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

