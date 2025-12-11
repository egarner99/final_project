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

The new script seems to work! Files are in the correct dir and it was copied, and no fails on the slurm file. Moved onto running the `run_fastqc.sh` script with the new files, again with code following the new file/script organization. 

# 12/7/25: 

Checked three of the new .html files to the old ones from before; they all matched indicating that everything worked properly. The slurms were also moved with the fastqc results. I re-ran the trimgalore script as well based on the new organization. While it was running, I worked on the `run_star_align.sh` script. I followed the example in the class website (Week 9 exercises). It recommended adding a few other options: `--alignIntronMin`, `--alignIntronMax`, and `--outFilterMultimapNmax`. Using GitHub Copilot, it recommended the option `--alignIntronMin` of 20 and an `--alignIntronMax` of 500,000 as general options for plants, so those are the ones I used. It also described what both are used are, and they basically set a guidline for the smallest and largest base pair size that Star will consider a splice intron. Interestingly, when I searched up `--outFilterMultimapNmax` on the `--help` section for Star, nothing came up so I left it alone. I also started on a basic outline for the loop to run the script:

```bash
for Seq_1 in ../final_project/results/trimgalore/SRR*-Seq_1_trimmed.fq.gz; do
    Seq_2=${Seq_1/-Seq_1/-Seq_2}
    sbatch scripts/run_star_align.sh "$Seq_1" "$Seq_2" results/star_index/ data/GCF/.gtf  results/star_align
```

After the trimgalore script ran, I re-ran the `run_star_index.sh` script using the GCF_Williams82_data files based again on the new organization. The new code to run trimgalore and star_index are as follows: 

TrimGalore: 
```bash
for Seq_1 in ../final_project/data/GM137_data/SRR*-Seq_1.fastq.gz; do
    Seq_2=${Seq_1/-Seq_1/-Seq_2}
    sbatch scripts/run_trimgalore.sh "$Seq_1" "$Seq_2" results/trimgalore
done
```

Star (for index): 
```bash
sbatch scripts/run_star_index.sh data/GCF_Williams82_data/ncbi_dataset/GCF_000004515.6/GCF_000004515.6_Glycine_max_v4.0_genomic.fna data/GCF_Williams82_data/ncbi_dataset/GCF_000004515.6/genomic.gtf results/star/index/
```

# 12/9/25: 

Some slight edits were done on the `run_star_index.sh` script yesterday, including realizing the `--runThreads` option did not match the number of cores requested. Might have to run again, especially because I actually don't think the reference genome file is unzipped, because it was an .fna. Also worked on the loop for Star align (I believe not yesterday but on the 7th). 

Re-read advice from GitHub Copilot again, since I have mixed read lengths it actually recommended using the largest read length. Using the code they gave me before, but remvoing the head -n 1, the longest length from the list was 158: 

```bash
awk 'NR%4==2 {print length}' your_file.fastq | sort | uniq -c | sort -rn 
```

However, after my presentation and the questions that I got, it became clear that I had a misunderstanding of the --sjdbOverhang option. I was calculating the sequence lengths from the reference genome, but I actually needed to do so for my GM137 trimmed files. With help from GitHub copilot, I tried to do a bit of trial and error to see if I could get the read length, such as trying the previous command with `awk`, but it wasn't working. I then tried the `seqkit` container based on its recommendation; it did seem to work to find the max length of reads for one file: 

```bash
apptainer exec oras://community.wave.seqera.io/library/seqkit:2.12.0--ec0d76090cceee7c seqkit stats -a results/trimgalore/SRR24727827_GSM7426424_Gm137_noninfected_RNA_bio_rep_3_Glycine_max_RNA-Seq_2_val_2.fq.gz
```

But, I would have to write a completely new script to run all the files (or do this command for each one individually), and I was unsure how to only get the max length statistic and not the others. Finally, I thought a simplier option would actually just be to check the .html files, and it was! It says the reads have a range from 20-150 bp, so I would use 150 to calculate the option for sjdbOverhang: `--sjdbOverhang 149` (the file I ran in seqkit also had similar results). I fixed that in the script, and will be using it to re-run the index (after I re-run trimgalore, it seems one of the files was accidentally deleted). 

`run_star_index.sh` was errors were fixed and it was re-run with the reference genome. Once that was completed, I worked on running the `run_star_align.sh` script. As the script was done with help from the class website (and Copilot) there were some things I had to change in the code match my files, such as in regards to extracting the sample ID, and with my loop: 

Star (for align): 

```bash
for Seq_1 in ../final_project/results/trimgalore/SRR*-Seq_1_val_1.fq.gz; do
    Seq_2=${Seq_1/-Seq_1_val_1/-Seq_2_val_2}
    sbatch scripts/run_star_align.sh "$Seq_1" "$Seq_2" results/star/index/ data/GCF_Williams82_data/genomic.gtf results/star/align/
done
```

It seemed to work well, but I will have to confirm with Jelmer and Menuka tomorrow. It gave output files that have information about the mapped reads. Once I confirm it worked correctly, I will also get started on FeatureCounts, with the goal of having a script by tomorrow. 

### Note: 
For my final project presentation, I looked at a few references that helped me to further understand some of the options for Star index & align. This is the reference list: 

- Doblin, A. 2019. STAR manual 2.7.0a. https://physiology.med.cornell.edu/faculty/skrabanek/lab/angsd/lecture_notes/STARmanual.pdf. Cornell University editor(s). Cornell University, Ithaca, NY. 

- Regan, K., Saghafi, A., Li, Z. 2021. Splice Junction Identification using Long Short-Term Memory Neural Networks. Curr Genomics. 22:384-390. 

- Anonymous. Mapping using Star. https://biocorecrg.github.io/RNAseq_course_2019/alnpractical.html. Biocore editor(s). Barcelona, Spain.

- Anonymous. 2013. What’s the difference between a bam and sorted bam. https://www.seqanswers.com/forum/bioinformatics/bioinformatics-aa/29595-what-s-the-difference-between-a-bam-and-a-sorted-bam. 

- Sultana, M.S., Niyikiza, D., Hawk, T.E., Coffey, N., Lopes-Caitar, V., Pfotenhauer, A.C., El-Messidi, H., Wyman, C., Pantalone, V., Hewezi, T. 2024. Differential Transcriptome Reprogramming Induced by the Soybean Cyst Nematode Type 0 and Type 1.2.5.7 During Resistant and Susceptible Interactions. Mol Plant Microbe Interact. 37:828-840.

- Anonymous. 2025. Understanding Soybean Cyst Nematode Genetic Resistance. https://www.cropscience.bayer.us/articles/bayer/understanding-scn-genetic-resistance. Bayer Crop Science editor(s). Bayer, Whippany, NJ. 


# 12/10/25: 

Confirmed the output was good with Jelmer, he also mentioned that featureCounts is found in the `subread` package: oras://community.wave.seqera.io/library/subread:2.1.1--bae420bffb4edf16. The container can be opened with:

```bash
apptainer exec oras://community.wave.seqera.io/library/subread:2.1.1--bae420bffb4edf16 featureCounts
```

I created a script for running FeatureCounts, using both GitHub Copilot, the featureCounts program help section, and two websites for help (Harrington, R. FeatureCounts. https://rnnh.github.io/bioinfo-notebook/docs/featureCounts.html.; Anonymous. 2021. featureCounts: a ultrafast and accurate read summarization program. https://subread.sourceforge.net/featureCounts.html.). The script has a couple of options in the main section: 

```bash
apptainer exec "$FeatureCounts" featureCounts \
    -p \
    -B \
    -C \
    -T 8 \
    -a "$gtf" \
    -o "$outdir"/"$sample_id".txt \
    "$BAM_file"
```

`-a` is for inputting the gtf file, `-o` is to name the output files, `-T` is for threads (so its 8 to make the cpus) `-p` is for paired end data, and counts both of the reads together as pairs. `-B` and `-C` help with accuracy, and making sure only actual paired reads are counted on the same chromosome are counted. I also used the sample_id trick from the star align script as well for naming the output files. 

I created a loop to run featureCounts, and used it in the terminal:

```bash
for BAM_file in results/star/align/SRR*_Aligned.sortedByCoord.out.bam; do
    sbatch scripts/run_featurecounts.sh "$BAM_file" data/GCF_Williams82_data/genomic.gtf results/featurecounts/
done
```

After a quick tweak to make sure the version printed correctly, it seems to work pretty well! I was a bit concerned about the level of Unassigned_Multimapping on the summary text; I asked GitHub Copilot about it, among what it mentioned was that it is possibly due to duplicated sequences, the reference .gtf file is incomplete, etc. Essentially though, the recommendation was as long as the percentage of reads unassigned compared to the total amount of reads was low, it should be fine (for the first output it was around 3% and same for Unassigned_No-Features amounts, and Unassigned_Ambiguity was around 0.36%). I will again check the output with Jelmer tomorrow, and move onto MultiQC and R Studio if it looks good! 

# 12/11/25: 

Obtained the container for multiqc off of Seqera, similar to the others. Assigned it to a variable to make it easier to run: MultiQC=oras://community.wave.seqera.io/library/multiqc:1.33--e3576ddf588fa00d

Using the container help in terminal and this website for help: Anonymous. Running MultiQC. https://docs.seqera.io/multiqc/getting_started/running_multiqc, I worked on a draft of the main section of the script:

```bash
apptainer exec "$MultiQC" multiqc \
    --outdir "$outdir" \
    --template geo \
    --title "Star and FeatureCounts Summary" \
    --ignore data/star/slurms/ \
    --ignore data/featurecounts/slurms/ \
    results/star/align/ \
    results/featurecounts/
```

I changed the `results/star/align/` and `results/featurecounts/` to variables so that it can run easier. I chose the geo template for the output file. I also made sure to add `--ignore` for the slurm files in those two dirs just in case. I created the sbatch code to run the script: 

```bash
sbatch scripts/run_multiqc.sh results/star/align/ results/featurecounts/ results/multiqc/
```

Running the script worked, but the geo template was a bit hard on the eyes when I downloaded the .html file. I tried again with a different template (original) and it was much easier to see. It's a pretty cool summary, with a section for both featureCounts and Star. It shows information such as the percent assigned, aligned, and uniq aligned as well as a bar graph of the amount of reads assigned and unassigned for featureCounts. For STAR, it also had information on percent aligned, uniquely aligned, annonated splices, and more, as well as a bar graph of uniquely mapped, mapped to multiple or too many loci, and unmapped.




