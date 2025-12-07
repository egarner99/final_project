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

I also took a look into the reference genome that the authors of the data files used for their analysis to create their index. They used the Williams 82 soybean sequence Wm82.a2.v1, which can be found on Soybase, as well as on NCBI RefSeq as GCF_000004515.5. On NCBI, it has a more current version called GCF_000004515.6, so that is the one that I downloaded, along with its annotation GTF file. 

## 12/3/25: 

Today, I worked on the `run_star_index` script, using my previous scripts and the one on the Week 9 exercises page to help me create it. The page mentioned looking into the `--sjdbOverhang` and `--genomeSAindexNbases` option, so I added those as well. With the help of GitHub Copilot, it explained that `--sjdbOverhang` is how many bases on each side of a sequence to save during splice site, to help it with mapping. It mentioned that this can be determined by calculating `readlength - 1`, with the first read length and the most common read length of the file being determined using the following codes provided by Copilot: 

```bash
head -n 2 your_file.fastq | tail -n 1 | wc -c
```

```bash
awk 'NR%4==2 {print length}' your_file.fastq | sort | uniq -c | sort -rn | head -n 1
```

I got a value of 81 for the first one, and 80 for 3059158 reads, so I went with 80; although I originally thought that would mean the `--sjdbOverhang` option would be set to 99 due to a misunderstanding, GitHub copilot clarified that the option would be set as `--sjdbOverhang 79`. 

In regards to `--genomeSAindexNbases`, it recommended calculating by using the equation `(log2(genomeLength)/2 - 1)`, along with some other information. Based on this, I estimated that a value of 13 would work for the genome, since 14 is for larger genomes and 12 is for smaller genomes, and I confirmed it with Copilot. So, the final code looked like this: 

```bash
apptainer exec "$STAR" STAR \
    --runMode genomeGenerate \
     --genomeFastaFiles "$fasta" \
     --genomeDir "$outdir" \
     --sjdbGTFfile "$gtf" \
     --runthreadN 16 \
     --sjdbOverhang 79 \
     --genomeSAindexNbases 13
```
Ran the GCF and its corresponding gtf file by submitting a batch job using the following code: 

```bash
sbatch star/run_star_index.sh final_project/star/GCF_000004515.6_Williams82/ncbi_dataset/data/GCF_000004515.6/GCF_000004515.6_Glycine_max_v4.0_genomic.fna final_project/star/GCF_000004515.6_Williams82/ncbi_dataset/data/GCF_000004515.6/genomic.gtf star/results
```

# 12/6/25: 

Based on the comments that I got for my final progress report, I reworked the organization of my final_project dir. All the scripts were moved into a dir called `scripts/`, the result files from FastQC, TrimGalore, and Star were moved into a dir called `results/`, and a `data/` dir was made for the original downloaded GM137 files and the downloaded reference genome files. 

I also got a comment on how to use the wget command to download the data instead of using the complicated one from GitHub Copilot, changing the `-o` that the script on the SRA Explorer had to `-O`. I also added a section to move and copy the `downloads/` dir manually instead of doing it by hand. Once the data is done downloading, all scripts will be re-run with the changed code for the new organization to make sure everything works, as was recommended. 

New code to run the `run_data_download.sh` script: 

```bash
sbatch scripts/run_data_download.sh
```

I updated the protocol to what it should look like with the new organization. I also edited the protocol to download the reference file, and will use it for this second "run". I also decided to edit the `run_data_download.sh` script to more simply move the files into a dir called `GM137_data/` instead of `downloads/`, using advice from GitHub Copilot and the class website. I tried a few different things, adding `-P` at the beginning with the path to the dir (`data/GM137_data`), adding the dir as a path to the new file name with `-O` (which just made the file upload twice, once to the terminal and another to the dir I wanted), but what finally worked properly was moving the section with `-O` and the path to the dir + new file name to the front, and the `-L <url>` to the end. 
