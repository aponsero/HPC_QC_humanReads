# HPC_QC_humanReads
Pipeline for metagenomic QC and human read removal for HPC (SLURM) - Puhti CSC cluster

## Tools required

- Bowtie2 v 2.5.4
- TrimGalore v 0.6.10
- MultiQC v 1.25.1

### Installation :

First clone this repository on the HPC in a convenient folder location: 

```
git clone git@github.com:aponsero/HPC_QC_humanReads.git
```

To install the required tools for the pipeline on Puthi, please follow the instructions provided in the install.md file.

## Run the pipeline

A small test dataset can be downloaded and will be used to demonstrate how to use this pipeline.

### Download the test dataset

```
cd HPC_QC_humanReads/test
bash 1.download.sh
```

This will download a small dataset of two illumina paired-end metagenomes:

```
ERR9752384_Illumina_NovaSeq_6000_paired_end_sequencing_1.fastq.gz
ERR9752384_Illumina_NovaSeq_6000_paired_end_sequencing_2.fastq.gz
ERR9752385_Illumina_NovaSeq_6000_paired_end_sequencing_1.fastq.gz
ERR9752385_Illumina_NovaSeq_6000_paired_end_sequencing_2.fastq.gz
```

### Create the list of samples to process

Next, we need to create a list of files to process. Simply create a text document listing the sample prefix names. For our examples we provide a file 'list.txt' located in the test folder : 

```
ERR9752384_Illumina_NovaSeq_6000_paired_end_sequencing
ERR9752385_Illumina_NovaSeq_6000_paired_end_sequencing
```

### Edit the config files

Next, we need to edit the config file: config.sh

```
#!/bin/bash -l

# TYKKY containers locations
TYKKY_BOWTIE="$PWD/tykky/bowtie2_2.5.4/bin" # Path to the tykky container for bowtie
TYKKY_QC="$PWD/tykky/trim-galore_0.6.10/bin" # Path to the tykky container for trimGalore!
TYKKY_MULTIQC="$PWD/tykky/multiqc_1.25.1" # Path to the tykky container for multiQC

# human genome
HUM_DB="$PWD/human_database/GRCh38_noalt_as/GRCh38_noalt_as"

# INPUT LIST and  DIRECTORY
IN_LIST="$PWD/test/list.txt" # path to the list of files to process
IN_DIR="$PWD/test" # path to the input directory
OUT_DIR="$PWD/test/output" # path to outpout directory
FOR="_1.fastq.gz" # forward read extension string
REV="_2.fastq.gz" # reverse read extension string

# Type of metagenomes (for primer trimming)
TYPE="illumina" # choose between "illumina" or "MGI"

# SLURM account to bill
ACC_proj="" # your CSC project that will be used for billing in the format "project_1233"
```

### Run the pipeline

#### part1: 

To run the first step of the pipeline (QC and human read removal), submit the jobs as following:

```
bash 1_run_QC.sh
```

This command will submit a number of jobs as an array (2 in our test dataset). This will create the following outputs: 

```
qc_host
 |-logs
 |
 | |-ERR9752385_Illumina_NovaSeq_6000_paired_end_sequencing_host_removed_R1.fastq.gz_trimming_report.txt
 | |-ERR9752385_Illumina_NovaSeq_6000_paired_end_sequencing_host_removed_R2.fastq.gz_trimming_report.txt
 | |-ERR9752385_Illumina_NovaSeq_6000_paired_end_sequencing_host_removed_R2_val_2_fastqc.html
 | |-ERR9752385_Illumina_NovaSeq_6000_paired_end_sequencing_host_removed_R1_val_1_fastqc.html
 | |-ERR9752385_Illumina_NovaSeq_6000_paired_end_sequencing_hostmap.log
 | |-ERR9752385_Illumina_NovaSeq_6000_paired_end_sequencing_host_removed_R1_val_1_fastqc.zip
 | |-ERR9752385_Illumina_NovaSeq_6000_paired_end_sequencing_host_removed_R2_val_2_fastqc.zip
 |
 | |-ERR9752384_Illumina_NovaSeq_6000_paired_end_sequencing_host_removed_R1.fastq.gz_trimming_report.txt
 | |-ERR9752384_Illumina_NovaSeq_6000_paired_end_sequencing_host_removed_R2.fastq.gz_trimming_report.txt
 | |-ERR9752384_Illumina_NovaSeq_6000_paired_end_sequencing_host_removed_R2_val_2_fastqc.html
 | |-ERR9752384_Illumina_NovaSeq_6000_paired_end_sequencing_host_removed_R1_val_1_fastqc.html
 | |-ERR9752384_Illumina_NovaSeq_6000_paired_end_sequencing_hostmap.log
 | |-ERR9752384_Illumina_NovaSeq_6000_paired_end_sequencing_host_removed_R1_val_1_fastqc.zip
 | |-ERR9752384_Illumina_NovaSeq_6000_paired_end_sequencing_host_removed_R2_val_2_fastqc.zip
 |
 |-cleaned_reads
 | |-ERR9752385_Illumina_NovaSeq_6000_paired_end_sequencing_host_removed_R1_val_1.fq.gz
 | |-ERR9752385_Illumina_NovaSeq_6000_paired_end_sequencing_host_removed_R2_val_2.fq.gz
 | |-ERR9752384_Illumina_NovaSeq_6000_paired_end_sequencing_host_removed_R1_val_1.fq.gz
 | |-ERR9752384_Illumina_NovaSeq_6000_paired_end_sequencing_host_removed_R2_val_2.fq.gz
```

#### part2: 

To summarize the QC reports after metagenomic QC, run the multiQC summary:

```
bash 2_Run_MultiQC.sh
```

This will submit one very short job that will create the multiQC summary file in the qc_host/log folder.

