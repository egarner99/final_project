## Progress Report


<br>


In regards to my scripts, I will be writing a few different scripts for each step of the project. An individual script will be written (or has already been written) for downloading the data, running the files through FastQC, TrimGalore, Star, as well as FeatureCounts, and a Quarto document will be made for work in R. For the downloading data script, I had trouble getting the code that was supplied on the SRA Explorer website to work. So, I used GitHub Copilot to write a script for me to be able to download the data, while also changing the file names (as can be seen in the `downloading_files` dir, with the script `download_data.sh`). Though I still have to go back through to make sure I fully understand, I believe it accomplishes this task by using another text file (called `sra_files.txt`) along with the script. It reads the file, using `,` as a delimeter, with the first part of each line the file's url which it downloads, and the second part the file name that I want it changed to. However, I think that the code the AI gave me is a bit complicated, so any feedback on a simplier way to accomplish the same task would be much appreciated!


<br>


For the FastQC and TrimGalore scripts, I am following the examples and steps provided in the class website to create them. As suggested by Menuka, the purpose of running the FastQC script is to check the quality of the sequence files before running them through TrimGalore, to see if there are any polyG's, etc. that may need to be corrected from the .html files. TrimGalore will then trim the sequences to remove any of those errors and prepare them to be aligned to a reference genome. I have created and run scripts for both of these programs, however I may need to write a new loop to run the TrimGalore script, as I believe I need to run the files as paired ends (R1/R2), which I did not do with the results I have currently. I also noticed from the .html files once I ran the files through FastQC that several of the sequneces do have polyG's at the end, so I added the `-2color 20` option in the code to remove them. The FastQC and TrimGalore scripts can be found in the `fastqc` and `trimgalore` dirs, respectively. My protocol still needs to be updated, but the loops I used can be found in the `README_notebook.md` file if needed! If there are any tips or things that I should change with these scripts, please let me know, especially with the TrimGalore script. As mentioned, I am mainly following the processes and script/code examples provided in the class website, however I wasn't sure how close we're allowed to follow those. I know open-book research is allowed, but I am a bit concerned whether my work shouldn't be similar to the examples/processes present on the website; if they are too similar or if it is an issue please also let me know so I may fix it! 


<br>


In regards to Star and FeatureCounts, they will be used, as was suggested, to align the trimmed reads to a reference genome and to obtain read counts for those matches as well. I have yet to get started on working on these scripts, and will have to do some research/ask GitHub Copilot for tips and considerations on what to write for those. I am also unsure on where to find a reference genome for these sequences for Star; any advice on this process as well would be extremely helpful!


<br>


If I have time, I would also like to create a graph of the read counts in R, using ggplot and other tools we have learned in the class these past few weeks (with code put into a Quarto document). One uncertainity I have with this is how to input the data from FeatureCounts into R. I unfortunately think that figuring out the scripts for Star and FeatureCounts may take a while, so I am uncertain if I will get this far, but my ultimate goal is to do so.


<br>


## To-do List: 

1. Re-write loop for TrimGalore and run the files through again. 
2. Research and develop a script for both Star and FeatureCounts, determine how to find a reference genome to use. 
3. Gain a better understainding of the script provided for downloading data through GitHub Copilot; though not neccessarily needed, simplify it for future runs. 
4. Create a graph of the results from FeatureCounts in R.
5. Make sure to fully understand how each script and program works for this complete process. 


<br>


### Note:
 Please ignore the `first_attempt_data_download.sh` script and the `old_slurms` dir in `fastqc`, they are previous attempts/trials that I am saving for my reference for now, and will be removed once the final project is submitted. 