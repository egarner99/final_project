# Sequencing of soybean genotype 137 

- Author: Elisabeth Garner
- Date: Made on Oct. 31, 2025, last modified on Dec. 12, 2025
- Working Dir: /fs/ess/PAS2880/users/egarner99/final_project
- Environment: Pitzer 

<br>

## Project Description: 

Steps for gene expression analysis of RNA sequencing data from Soybean GM137 that was either noninfected, infected with H. glycines race 2, or H. glycines race 3. Data was used from a study conducted by Sultana et al., 2024. The project uses programs such as FASTQC, TrimGalore, Star, FeatureCounts, MultiQC, and R Studio. Steps lead to a Quarto document that can be used to create several graphs for gene expression analysis. 

<br>

## 10/31/25: 

Set-up a few dirs for the project.

Created a script to download the data from the SRA explorer. Initially, it didn't want to run (kept getting an error that the script was empty), but reloading the page fixed the issue. I added the email option for END and FAIL, so it should hopefully inform me if it works or not. 

<br>

See the `data_download.sh` script and `README_protocol.md` for details. 

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

<br>

I tried it to see if it would work, but it still failed with the same error. Instead, I used a script suggested from GitHub Copilot; we were allowed to ask questions that we could use to help us for our project during Graded Assignment #5. The question I asked was: "How do I write a script to download and rename files from the SRA Explorer at the same time?" (from Graded Assignment #5). I copied the script from my initial promoting of the question, followed the process that the AI described (see `README_protocol.md`), and ran the script. 

<br>

Using the script worked! All the files (18 in total for R1 and R2) were downloaded, renamed, and put into a downloads folder (and the final logging statement was in the slurm file). The slurm file was also moved into the downloads dir as well. A copy of the downloads folder was made (`downloads_copy`) and both were put into a folder called `GM137_data`. For now, I also made both of the downloads dirs read only. 

<br>

The `scripts` dir with the downloading scripts and `sra_files.txt` were put in a dir called `downloading_files`. 

<br>

## 11/25/25: 

Today I tried to create a script as well as attempted to run it to put the GM137 files through the FastQC program. Recommended by Menuka, I am running it through FastQC before TrimGalore to get an idea of what the sequences look like (if there are multiple N's at the end, etc.). I used the examples in the class website/notes to base my script on. The script is called `run_fastqc.sh` and is the dir `fastqc/`, which I created. 

<br>

The first run didn't work, and kept repeating the initial logging statment. After looking back at the notes, I realized that the looping code is what is put in the terminal, not the script, and that this portion is what is needed in the script instead: 

```bash
fastqc --outdir "$fastq" "$outdir"
```
<br>

I then realized that I had put this section in the script in the wrong order, based on the slurm files that I had gotten and again the class website:

```bash
fastqc --outdir "$outdir" "$fastq"
```

<br>

I re-ran the script again to see if it would work, and it seemed to do so! The outputs were put into a dir called `fastqc/results/`, and the slurm files were moved in the `fastqc/` dir in another folder called `slurms`. 

<br>

Either tomorrow or Friday, I will check each of the .html files, and use the information to create a script to run the files through TrimGalore. The whole fastqc/ dir was moved into `.gitignore`.

<br>

For now, I kept the slurms for the runs that did not work from today, for reference later. It is called `old_slurms`, and is also in the `fastqc/` dir. 

<br>

## 11/28/25: 

Checking the .html files, they all seem to have good per base sequence quality, although some of them seem to have an error in the per tile sequence quality, as well as errors in per base sequence content and sequence duplication levels. I will have to do some research to see if those are an issue, and if that means I need to add something to my trimgalore script. 

<br>

I also worked on the trimgalore script for the GM137 files, using the class website and the fastq script I made to help me create it and know what to include. Initially, I had trouble getting the correct code to download the container, but with help from GitHub Copilot I figured out that I needed to use the command `trim_galore` instead of `trimgalore` at the end. Checking the .html files, I also saw that some of them had polyG's at the end, so I added the `2color` option as well. After a bit of trial and error, I ran a trial run on a sequence that had the polyG's, with my script (`trimgalore/run_trimgalore`), using the command: 

```bash
sbatch trimgalore/run_trimgalore.sh GM137_data/downloads/SRR24727832_GSM7426419_Gm137_H._glycines_Race_2_infected_RNA_bio_rep_1_Glycine_max_RNA-Seq_2.fastq.gz trimgalore/results
```
<br>

## 11/29/25: 

After a bit more editing, my trial as seen above was able to work. With that in mind, I ran a loop for all of the files using the following code: 

```bash
for fastq in ../final_project/GM137_data/downloads/SRR*.fastq.gz; do
    sbatch trimgalore/run_trimgalore.sh "$fastq" trimgalore/results
done
```
<br>

## 12/2/25: 

I edited my loop to run the files as paired ends, with the following code: 

```bash
for Seq_1 in ../final_project/GM137_data/downloads/SRR*-Seq_1.fastq.gz; do
    Seq_2=${Seq_1/-Seq_1/-Seq_2}
    sbatch trimgalore/run_trimgalore.sh "$Seq_1" "$Seq_2" trimgalore/results
done
```

<br>

I initially had () around the second line instead of {} and ran it, those files will be removed once it is done since the loop was incorrect. 

<br>

I also changed my script to also run paired ends by adding `--paired` to the apptainer exec code, as well as changing `fastq=$1` to `Seq_1=$1` and `Seq_2=$2`. The `"$outdir"` was moved to `$3`. I also saw on the class website that a `--fastq` option can be added to automatically run FastQC again once the trimming is done, so I added that as well. I reran the files with these changes, and will check back later to see if it worked.

<br>

I also took a look into the reference genome that the authors of the data files used for their analysis to create their index. They used the Williams 82 soybean sequence Wm82.a2.v1, which can be found on Soybase, as well as on NCBI RefSeq as GCF_000004515.5. On NCBI, it has a more current version called GCF_000004515.6, so that is the one that I downloaded, along with its annotation GTF file. The website link to it is: https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000004515.6/.

<br>

## 12/3/25: 

Today, I worked on the `run_star_index` script, using my previous scripts and the one on the Week 9 exercises page to help me create it. The page mentioned looking into the `--sjdbOverhang` and `--genomeSAindexNbases` option, so I added those as well. With the help of GitHub Copilot, it explained that `--sjdbOverhang` is the number of bases on each side of a sequence to save for a splice site, to help it with mapping. It mentioned that this can be determined by calculating `readlength - 1`, with the first read length and the most common read length of the file being determined using the following codes provided by Copilot: 

<br>

```bash
head -n 2 your_file.fastq | tail -n 1 | wc -c
```

```bash
awk 'NR%4==2 {print length}' your_file.fastq | sort | uniq -c | sort -rn | head -n 1
```

<br>

I got a value of 81 for the first one, and 80 for 3059158 reads, so I went with 80; although I originally thought that would mean the `--sjdbOverhang` option would be set to 99 due to a misunderstanding, GitHub copilot clarified that the option would be set as `--sjdbOverhang 79`. 

<br>

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
<br>

Ran the GCF file and its corresponding .gtf file by submitting a batch job using the following code: 

```bash
sbatch star/run_star_index.sh final_project/star/GCF_000004515.6_Williams82/ncbi_dataset/data/GCF_000004515.6/GCF_000004515.6_Glycine_max_v4.0_genomic.fna final_project/star/GCF_000004515.6_Williams82/ncbi_dataset/data/GCF_000004515.6/genomic.gtf star/results
```

<br>

# 12/6/25: 

Based on the comments that I got for my final progress report, I reworked the organization of my final_project dir. All the scripts were moved into a dir called `scripts/`, the result files from FastQC, TrimGalore, and Star were moved into a dir called `results/`, and a `data/` dir was made for the original downloaded GM137 files and the downloaded reference genome files. 

<br>

I also got a comment on how to use the wget command to download the data instead of using the complicated one from GitHub Copilot, changing the `-o` that the script on the SRA Explorer had to `-O`. I also added a section to move and copy the `downloads/` dir manually instead of doing it by hand. Once the data is done downloading, all scripts will be re-run with the changed code for the new organization to make sure everything works, as was recommended. 

<br>

New code to run the `run_data_download.sh` script: 

```bash
sbatch scripts/run_data_download.sh
```

<br>

I updated the protocol to what it should look like with the new organization. I also edited the protocol to download the reference file, and will use it for this second "run". I also decided to edit the `run_data_download.sh` script to download the files and simply move the files into a dir called `GM137_data/` instead of `downloads/`, using advice from GitHub Copilot and the class website. I tried a few different things, adding `-P` at the beginning with the path to the dir (`data/GM137_data`), adding the dir as a path to the new file name with `-O` (which just made the file upload twice, once to the terminal and another to the dir I wanted), but what finally worked properly was moving the section with `-O` and the path to the dir + new file name to the front, and the `-L <url>` to the end. 

<br>

The new script seems to work! Files are in the correct dir and it was copied, and no fails on the slurm file. Moved onto running the `run_fastqc.sh` script with the new files, again with code following the new file/script organization. 

<br>

# 12/7/25: 

Checked three of the new .html files to the old ones from before; they all matched indicating that everything worked properly. The slurms were also moved with the fastqc results. I re-ran the trimgalore script as well based on the new organization. While it was running, I worked on the `run_star_align.sh` script. I followed the example in the class website (Week 9 exercises). It recommended adding a few other options: `--alignIntronMin`, `--alignIntronMax`, and `--outFilterMultimapNmax`. Using GitHub Copilot, it recommended the option `--alignIntronMin` of 20 and an `--alignIntronMax` of 500,000 as general options for humans/plants, so those are the ones I used. It also described what both are used are, and they basically set a guidline for the smallest and largest base pair size that Star will consider a splice intron. Interestingly, when I searched up `--outFilterMultimapNmax` on the `--help` section for Star, nothing came up so I left it alone. I also started on a basic outline for the loop to run the script:

<br>

```bash
for Seq_1 in ../final_project/results/trimgalore/SRR*-Seq_1_trimmed.fq.gz; do
    Seq_2=${Seq_1/-Seq_1/-Seq_2}
    sbatch scripts/run_star_align.sh "$Seq_1" "$Seq_2" results/star_index/ data/GCF/.gtf  results/star_align
```

<br>

After the trimgalore script ran, I re-ran the `run_star_index.sh` script using the GCF_Williams82_data files based again on the new organization. The new code to run trimgalore and star_index are as follows: 

TrimGalore: 
```bash
for Seq_1 in ../final_project/data/GM137_data/SRR*-Seq_1.fastq.gz; do
    Seq_2=${Seq_1/-Seq_1/-Seq_2}
    sbatch scripts/run_trimgalore.sh "$Seq_1" "$Seq_2" results/trimgalore
done
```
<br>

Star (for index): 
```bash
sbatch scripts/run_star_index.sh data/GCF_Williams82_data/ncbi_dataset/GCF_000004515.6/GCF_000004515.6_Glycine_max_v4.0_genomic.fna data/GCF_Williams82_data/ncbi_dataset/GCF_000004515.6/genomic.gtf results/star/index/
```

<br>

# 12/9/25: 

Some slight edits were done on the `run_star_index.sh` script yesterday, including realizing the `--runThreads` option did not match the number of cores requested. Might have to run again, especially because I actually don't think the reference genome file is unzipped, because it was an .fna. Also worked on the loop for Star align (I believe not yesterday but on the 7th). 

<br>

Re-read advice from GitHub Copilot again, since I have mixed read lengths it actually recommended using the largest read length. Using the code they gave me before, but remvoing the head -n 1, the longest length from the list was 158: 

<br>

```bash
awk 'NR%4==2 {print length}' your_file.fastq | sort | uniq -c | sort -rn 
```

<br>

However, after my presentation and the questions that I got, it became clear that I had a misunderstanding of the `--sjdbOverhang` option. I was calculating the sequence lengths from the reference genome, but I actually needed to do so for my GM137 trimmed files. With help from GitHub copilot, I tried to do a bit of trial and error to see if I could get the read length, such as trying the previous command with `awk`, but it wasn't working. I then tried the `seqkit` container and code based on its recommendation; it did seem to work to find the max length of reads for one file: 

```bash
apptainer exec oras://community.wave.seqera.io/library/seqkit:2.12.0--ec0d76090cceee7c seqkit stats -a results/trimgalore/SRR24727827_GSM7426424_Gm137_noninfected_RNA_bio_rep_3_Glycine_max_RNA-Seq_2_val_2.fq.gz
```

<br>

But, I would have to write a completely new script to run all the files (or do this command for each one individually), and I was unsure how to only get the max length statistic and not the others. Finally, I thought a simplier option would actually just be to check the .html files, and it was! It says the reads have a range from 20-150 bp, so I would use 150 to calculate the option for sjdbOverhang: `--sjdbOverhang 149` (the file I ran in seqkit also had similar results). I fixed that in the script, and will be using it to re-run the index (after I re-run trimgalore, it seems one of the files was accidentally deleted). 

<br>

`run_star_index.sh` errors were fixed and it was re-run with the reference genome. Once that was completed, I worked on running the `run_star_align.sh` script. As the script was done with help from the class website (and Copilot) there were some things I had to change in the code match my files, such as in regards to extracting the sample ID, and with my loop: 

Star (for align): 

```bash
for Seq_1 in ../final_project/results/trimgalore/SRR*-Seq_1_val_1.fq.gz; do
    Seq_2=${Seq_1/-Seq_1_val_1/-Seq_2_val_2}
    sbatch scripts/run_star_align.sh "$Seq_1" "$Seq_2" results/star/index/ data/GCF_Williams82_data/genomic.gtf results/star/align/
done
```

<br>


It seemed to work well, but I will have to confirm with Jelmer and Menuka tomorrow. It gave output files that have information about the mapped reads. Once I confirm it worked correctly, I will also get started on FeatureCounts, with the goal of having a script by tomorrow. 

<br>

### Note: 
For my final project presentation, I looked at a few references that helped me to further understand my project, as wel as some of the options for Star index & align, including the class website, GitHub Copilot, and their `--help` pages. This is the reference list: 

- Doblin, A. 2019. STAR manual 2.7.0a. https://physiology.med.cornell.edu/faculty/skrabanek/lab/angsd/lecture_notes/STARmanual.pdf. Cornell University editor(s). Cornell University, Ithaca, NY. 

- Regan, K., Saghafi, A., Li, Z. 2021. Splice Junction Identification using Long Short-Term Memory Neural Networks. Curr Genomics. 22:384-390. 

- Anonymous. Mapping using Star. https://biocorecrg.github.io/RNAseq_course_2019/alnpractical.html. Biocore editor(s). Barcelona, Spain.

- Anonymous. 2013. What’s the difference between a bam and sorted bam. https://www.seqanswers.com/forum/bioinformatics/bioinformatics-aa/29595-what-s-the-difference-between-a-bam-and-a-sorted-bam. 

- Sultana, M.S., Niyikiza, D., Hawk, T.E., Coffey, N., Lopes-Caitar, V., Pfotenhauer, A.C., El-Messidi, H., Wyman, C., Pantalone, V., Hewezi, T. 2024. Differential Transcriptome Reprogramming Induced by the Soybean Cyst Nematode Type 0 and Type 1.2.5.7 During Resistant and Susceptible Interactions. Mol Plant Microbe Interact. 37:828-840.

- Anonymous. 2025. Understanding Soybean Cyst Nematode Genetic Resistance. https://www.cropscience.bayer.us/articles/bayer/understanding-scn-genetic-resistance. Bayer Crop Science editor(s). Bayer, Whippany, NJ. 

<br>

# 12/10/25: 

I confirmed the output was good with Jelmer, he also mentioned that featureCounts is found in the `subread` package: oras://community.wave.seqera.io/library/subread:2.1.1--bae420bffb4edf16. The container can be opened with:

```bash
apptainer exec oras://community.wave.seqera.io/library/subread:2.1.1--bae420bffb4edf16 featureCounts
```
<br>

I created a script for running FeatureCounts using both GitHub Copilot, the featureCounts program help section, and two websites for help (Harrington, R. FeatureCounts. https://rnnh.github.io/bioinfo-notebook/docs/featureCounts.html.; Anonymous. 2021. featureCounts: a ultrafast and accurate read summarization program. https://subread.sourceforge.net/featureCounts.html.). The script has a couple of options in the main section: 

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

<br>

`-a` is for inputting the gtf file, `-o` is to name the output files, `-T` is for threads (so its 8 to make the cpus) `-p` is for paired end data, and counts both of the reads together as pairs. `-B` and `-C` help with accuracy, and making sure only actual paired reads are counted on the same chromosome are counted. I also used the sample_id trick from the star align script as well for naming the output files. 

<br>

I created a loop to run featureCounts, and used it in the terminal:

```bash
for BAM_file in results/star/align/SRR*_Aligned.sortedByCoord.out.bam; do
    sbatch scripts/run_featurecounts.sh "$BAM_file" data/GCF_Williams82_data/genomic.gtf results/featurecounts/
done
```
<br>

After a quick tweak to make sure the version printed correctly, it seems to work pretty well! I was a bit concerned about the level of Unassigned_Multimapping on the summary text; I asked GitHub Copilot about it, among what it mentioned was that it is possibly due to duplicated sequences, the reference .gtf file is incomplete, etc. Essentially though, the recommendation was as long as the percentage of reads unassigned compared to the total amount of reads was low, it should be fine (for the first output it was around 3% and same for Unassigned_No-Features amounts, and Unassigned_Ambiguity was around 0.36%). I will again check the output with Jelmer tomorrow, and move onto MultiQC and R Studio if it looks good! #!/usr/bin/env python3
import sys
import pandas as pd
import os

# featureCounts directory
fc_dir = sys.argv[1] if len(sys.argv) > 1 else "results/featurecounts"
output_file = sys.argv[2] if len(sys.argv) > 2 else "counts_matrix.txt"

# find all featureCounts output files (exclude .summary files)
fc_files = sorted([f for f in os.listdir(fc_dir) if f.endswith('.txt') and not f.endswith('.summary')])

if not fc_files:
    print(f"No featureCounts files found in {fc_dir}")
    sys.exit(1)

# read first file to get gene IDs
first_file = os.path.join(fc_dir, fc_files[0])
df = pd.read_csv(first_file, sep='\t', skiprows=1, usecols=[0, 6], names=['Geneid', fc_files[0].split('.')[0]])

# read remaining files and add their count columns
for fc_file in fc_files[1:]:
    sample_name = fc_file.split('.')[0]
    path = os.path.join(fc_dir, fc_file)
    tmp = pd.read_csv(path, sep='\t', skiprows=1, usecols=[0, 6], names=['Geneid', sample_name])
    df = df.merge(tmp, on='Geneid', how='outer')

# sort by gene ID and save
df = df.sort_values('Geneid')
df.to_csv(output_file, sep='\t', index=False)
print(f"Combined counts matrix saved to {output_file}")
print(f"Dimensions: {df.shape[0]} genes x {df.shape[1]-1} samples")

<br>

# 12/11/25: 

Obtained the container for MultiQc off of Seqera, similar to the others. Assigned it to a variable to make it easier to run: `MultiQC=oras://community.wave.seqera.io/library/multiqc:1.33--e3576ddf588fa00d`.

<br>

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

<br>

I changed the `results/star/align/` and `results/featurecounts/` to variables so that it can run easier. I chose the geo template for the output file. I also made sure to add `--ignore` for the slurm files in those two dirs just in case. I created the sbatch code to run the script: 

```bash
sbatch scripts/run_multiqc.sh results/star/align/ results/featurecounts/ results/multiqc/
```
<br>

Running the script worked, but the geo template was a bit hard on the eyes when I downloaded the .html file. I tried again with a different template (original) and it was much easier to see. It's a pretty cool summary, with a section for both featureCounts and Star. It shows information such as the percent assigned, aligned, and uniq aligned as well as a bar graph of the amount of reads assigned and unassigned for featureCounts. For STAR, it also had information on percent aligned, uniquely aligned, annonated splices, and more, as well as a bar graph of uniquely mapped, mapped to multiple or too many loci, and unmapped.

<br>

Started taking a look at the protocol for DESeq2 and realized that I need a count table of all of the samples together, not one for each BAM file. With help from GitHub Copilot, I fixed my script and the sbatch command to run again. For the sbatch command, instead of using a variable for the BAM files I put them into the script, similar to how Copilot showed, so that it would run properly (kept trying to make a dir out of one of the files): 

```bash
apptainer exec "$FeatureCounts" featureCounts \
    -p \
    -B \
    -C \
    -T 8 \
    -a "$gtf" \
    -o "$outdir"/"GM137_samples".tsv \
    results/star/align/SRR*_Aligned.sortedByCoord.out.bam
```

<br>

 Once it was done, I re-ran MultiQC, and it gave pretty much the same information on the .html file (but now all of the count data is in one .txt file).

<br>

I also created a metadata.tsv file, using some of the information from the GM137's metadata file found on NCBI, advice from Menuka and Jelmer, and examples seen with GitHub Copilot. I created a column for sample_id and a column for treatment.

<br>

However, when put into R, it wasn't registering as two columns. For some reason, clicking Tab on my Mac did not create tabs at all, only spaces. I tried a couple of commands from GitHub to try to troubleshoot: 

<br>

To confirm the amount of columns, when run it just output OK, then later `bad line 11 Okay`: 

```bash
awk -F'\t' 'NR==1{c=NF} NF!=c{print "bad line",NR; exit} END{print "OK"}' data/GM137_data/metadata.tsv
``` 
<br>

I was a bit confused with the code and its outputs, but it gave me many other options to try. One was to make the contents of the file appear in the terminal, but it still looked like tabs to me:

```bash
column -t -s $'\t' data/GM137_data/metadata.tsv | head
```

<br>


I also tried this command, but it didn't output `no tabs found`, which made me even more confused: 

```bash
grep -n $'\t' data/GM137_data/metadata.tsv | head -n1 || echo "no tabs found"
```

<br>


I started to try one other command, but finally I started looking more into this command, which basically outputs symbols for different characters, such as spaces or tabs, and it will do it for the first line: 

```bash
head -n3 data/GM137_data/metadata.tsv | sed -n '1l'
```
<br>

It mentioned that tabs are supposed to be `/t` which was not appearing in the output: `sample_id   treatment$`. From there I realized it must be a problem with the Tab on my Mac. I tried a quick search on Google but didn't get an answer I was looking for (this website, https://stackoverflow.com/questions/35519538/why-is-the-visual-studio-code-tab-key-not-inserting-a-tab, mentioned trying Ctrl+M to fix), but one solution Copilot gave for VS Code was to change the Spaces (Spaces:4 I assumed) option on the bottom to tab, and that worked to get the tab to appear as seen with the `sed` command: `sample_id\ttreatment$`. It finally got R Studio to recognize the file as having two columns. 

<br>

Unfortunately, I am also having a similar problem with the featurecounts file. I thought it was an extra option I would have to add to the script, Copilot said I could simply change the script to do so by outputting a .tsv file. I re-ran it and multiqc as well, but it still didn't work. GitHub gave me code to remove the comment line at the top; at first I instead just made a copy of the file, deleted the line and shifted the rest up, and that worked in R Studio. However, I wanted a way to do so without editing the file manually, Copilot gave a few options, one of which two lines of code for R: 

<br>

```bash
counts <- read.delim("results/featurecounts/combined_counts.txt", skip=1, row.names=1)
counts <- counts[, -(1:5)]
```
<br>

For it to work with my file however, I changed it to: 

```bash
count <- read.tsv(count_data, skip=1)
count_file <- count[, -(2:6)]
```

If I understand correctly, the first line skips the comment line in the new file, and the second one removes the character, start, end, and length columns, similar to how Copilot said it would just with some edits. 

<br>

Continuing with following the steps in the class website, one issue I came to is that the column and row names for the metadata and tsv files are not the same. 

<br>

# 12/11/25: 

To get the names on the featureCounts count table and the metadata file to match while also not being too long, I changed my script to copy and rename the .bam files from Star to a shorter name, and then ran featureCounts with those files. I also re-ran MultiQC so all the files match. Unfortunately, although copy and renaming worked for the featureCounts file, it caused some errors with the multiqc .html file, and wouldn't match how the output looked before. I tried a few different things, even changing the multiqc script to instead just take the new .bam files instead of the whole star/align/ dir, but it didn't match the original .html output. I decided to re-run both again as was done before (with the original files), and tried to see if I could change the names in R instead with the tables. I tried the rename function mentioned in the class website, but it didn't seem to work as seen with a couple of the commands I tried below (I believe this is all the ones I tried, I may have missed a few). I eventually figured out how the rename command is supposed to work, but I would still get errors. Copilot recommended putting tick marks around the column name (as seen with the fourth and fifth command), but I still got errors as well: 

<br>

```{r}
rename(.data = count_matches, SRR24727827 = results/star/align/SRR24727827_GSM7426424_Gm137_noninfected_RNA_bio_rep_3_Glycine_max_RNA_Aligned.sortedByCoord.out.bam)
```

<br>

```{r}
rename(.cols, count_matches, SRR24727827 = results/star/align/SRR24727827_GSM7426424_Gm137_noninfected_RNA_bio_rep_3_Glycine_max_RNA_Aligned.sortedByCoord.out.bam)
```

<br>

```{r}
rename(count_matches, SRR24727827 = results/star/align/SRR24727827_GSM7426424_Gm137_noninfected_RNA_bio_rep_3_Glycine_max_RNA_Aligned.sortedByCoord.out.bam)
```

<br>

```{r}
rename(count_matches, SRR24727827 = `results/star/align/SRR24727827_GSM7426424_Gm137_noninfected_RNA_bio_rep_3_Glycine_max_RNA_Aligned.sortedByCoord.out.bam`)
```

<br>

```{r}
count_matches <- count_matches |>
  rename(
 SRR24727827 = `results/star/align/SRR24727827_GSM7426424_Gm137_noninfected_RNA_bio_rep_3_Glycine_max_RNA_Aligned.sortedByCoord.out.bam`
   )
```

<br>

Eventually, I tried the other option Copilot gave me with this command: 

```{r}
colnames(count_matches)[colnames(count_matches) ==
  "results/star/align/SRR24727827_GSM7426424_Gm137_noninfected_RNA_bio_rep_3_Glycine_max_RNA_Aligned.sortedByCoord.out.bam"] <-
  "SRR24727827"
```

<br>

And it worked successfully. I made a section of this code for each of the column names, and changed it for count_file instead of count_matches. If I understand correctly, it essentially selects the column names, reassignes them to the new name, and then saves them as that name. It worked to make sure that row names and column names were the same. 

<br>

**Using the steps and code detailed in the Week14A lecture (RNA-Seq count data analysis in R)**, I created a PCA plot for all of the treatments, a Volcano plot for each of the treatments, and a boxplot for one of the most signficantly expressed genes. Compared my PCA plot to the one in the original paper as well, seemed to look good in regards to how they are grouped together. For organization, the Quarto and .html file were moved into a dir called `r_studio/`: 

```bash
mkdir r_studio/
mv deseq2_steps* r_studio/
```

<br>

Once everything was looked over, I deleted the `old_stuff/` dir with the previous trials. Unfortunately, I couldn't figure out how to delete my git commits for the dirs from before I re-organized the `final_project/` dir, so I left those alone.

<br>

Learned a lot working on this project! 


<br>


### References: 

- Doblin, A. 2019. STAR manual 2.7.0a. https://physiology.med.cornell.edu/faculty/skrabanek/lab/angsd/lecture_notes/STARmanual.pdf. Cornell University editor(s). Cornell University, Ithaca, NY. 

- Regan, K., Saghafi, A., Li, Z. 2021. Splice Junction Identification using Long Short-Term Memory Neural Networks. Curr Genomics. 22:384-390. 

- Cozzuto, L., Ponomarenko, J., Bonnin, S. 2019. Mapping using Star. https://biocorecrg.github.io/RNAseq_course_2019/alnpractical.html. Biocore editor(s). Barcelona, Spain.

- Anonymous. 2013. What’s the difference between a bam and sorted bam. https://www.seqanswers.com/forum/bioinformatics/bioinformatics-aa/29595-what-s-the-difference-between-a-bam-and-a-sorted-bam. 

- Sultana, M.S., Niyikiza, D., Hawk, T.E., Coffey, N., Lopes-Caitar, V., Pfotenhauer, A.C., El-Messidi, H., Wyman, C., Pantalone, V., Hewezi, T. 2024. Differential Transcriptome Reprogramming Induced by the Soybean Cyst Nematode Type 0 and Type 1.2.5.7 During Resistant and Susceptible Interactions. Mol Plant Microbe Interact. 37:828-840.

- Anonymous. 2025. Understanding Soybean Cyst Nematode Genetic Resistance. https://www.cropscience.bayer.us/articles/bayer/understanding-scn-genetic-resistance. Bayer Crop Science editor(s). Bayer, Whippany, NJ. 

- Harrington, R. FeatureCounts. https://rnnh.github.io/bioinfo-notebook/docs/featureCounts.html.

- Anonymous. 2021. featureCounts: a ultrafast and accurate read summarization program. https://subread.sourceforge.net/featureCounts.html.

- Anonymous. Running MultiQC. https://docs.seqera.io/multiqc/getting_started/running_multiqc

- Why is the Visual Studio Code Tab Key not inserting a tab?. https://stackoverflow.com/questions/35519538/why-is-the-visual-studio-code-tab-key-not-inserting-a-tab.

- Poelstra, J. and Bhandari, M. 2025. Practical Computing Skills for Omics Data. https://mcic-osu.github.io/pracs-au25/. Department of Plant Pathology editor(s). Department of Plant Pathology, Ohio State Univeristy, Columbus, OH. 

- GitHub Copilot