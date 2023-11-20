# HPC_QC_humanReads
QC and human read removal parallel pipeline for HPC (SLURM)

## Tools required

- Bowtie2 v 2.5.1
- TrimGalore v 0.6.10

### Installation :
Generate a Tykky container or a conda environment using the yml environment description file provided in the config folder

## Run pipeline
Edit the config.sh file and provide a list of sample to process in parallel.
Submit the pipeline using the submit script 1_run_QC.sh. The script will sumit each samples in the list in parallel.
