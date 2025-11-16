## Final Project - Proposal

With this project I hope to practice the process used to analyze RNA sequencing data. I want my project to be focused on this to help me to analyze similar data in the future for my thesis. I will be working with .fastq files from Illumina sequencing from an article titled: *Differential transcriptome reprogramming induced by the soybean cyst nematode Type 0 and Type 1.2.5.7 during resistant and susceptible interactions* (Sultana et al., 2024). Specifically, I will being using the files for the soybean genotype GM137. At the very least, I would like to obtain a count table of the different reads, but my ultimate goal will be to again analyze expression levels using R. 

<br>
I will be following the workflow recommended to me by Dr. Poelstra and which was also described in the lectures/class website (such as in the sequence file types presentation) and practiced throughout the course. Following this process, I will first download the data from the SRA Explorer (was already done with help from GitHub Copilot), trim the data using TrimGalore, map the reads using STAR, and upon recommendation from Dr. Poelstra, will use FeatureCounts to count the reads. Each section will have a different dir in the final project directory that has the scripts and neccessary files to run each program. It will be split up this way for organization and to make sure that each step can be run correctly and individually if needed, as we were taught. The scripts will include loops to be able to run through each file, and will be run using the sbatch command, as they are larger files. Any results (except for the files from the data download) will also be stored in the same dirs as the scripts. As was recommended in the course, I will also have a README that will contain my notes with the work I did/tried each day, and another that will serve as more of a complete protocol. Finally, I will use R to analyze expression levels. 

<br>
In regards to what parts of the project I am still uncertain about, while I have somewhat of an understanding of how the RNA sequencing pipeline should work, I still have some questions about why each part is needed, or what they do. The course Github site has been helpful so far (and I have some notes written down with the process from the lectures/class website), but I may need to go back through to make sure I fully understand. There are also some scripts for programs that I haven't had experience writing yet, such as for STAR and FeatureCounts, that might take me a while to get correct. I also am still deciding if I want to subsample the reads, however I believe I will just stick with the totality of the GM137 files. We also have just started working with R, so I am nervous I may not have the understanding of the program that I need in order to analyze expression levels. Additionally, I'm not sure how we can use the program to go about doing so, but I'm sure it will be further explained throughout the course, and I may just have some extra research to do. 

<br>
As mentioned, I picked this project because I will have to do RNA sequencing and analyze expression levels with my own project for my Master's thesis. I hope that by practicing the process with this final project, I will be able to expand my knowledge on how the process works, to be able to do it in the future with ease.

<br>

### References: 

Sultana, M.S., Niyikiza, D., Hawk, T.E., Coffey, N., Lopes-Caitar, V., Pfotenhaur, A., El-Messidi, H., Wyman, C., Pantalone, V., Hewezi, T. 2024. Differential Transcriptome Reprogramming Induced by the Soybean Cyst Nematode Type 0 and Type 1.2.5.7 During Resistant and Susceptible Interactions. Mol Plant Microbe Interact. 37:828-840. 

Poelstra, J. 2025. Practical Computing Skills for Omics Data. https://mcic-osu.github.io/pracs-au25/ref/about.html. CFAES Bioinformatics Core, Wooster, OH.

