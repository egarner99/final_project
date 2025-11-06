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

The scripts dir for the downloads scripts & README.md files were made using the create new ile/folder options in VS code. However, they can also be created using: 

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