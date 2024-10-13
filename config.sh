#!/bin/bash -l

# TYKKY containers locations
TYKKY_BOWTIE="$PWD/tykky/bowtie2_2.5.4/bin" # Path to the tykky container for bowtie
TYKKY_QC="$PWD/tykky/trim-galore_0.6.10/bin" # Path to the tykky container for trimGalore!
TYKKY_MULTIQC="$PWD/tykky/multiqc_1.25.1/bin" # Path to the tykky container for multiQC

# human genome
HUM_DB="$PWD/human_database/GRCh38_noalt_as/GRCh38_noalt_as"

# INPUT LIST and  DIRECTORY
IN_LIST="$PWD/test/list.txt" # path to the list of files to process
IN_DIR="$PWD/test" # path to the input directory
OUT_DIR="$PWD/test" # path to outpout directory
FOR="_1.fastq.gz" # forward read extension string
REV="_2.fastq.gz" # reverse read extension string

# Type of metagenomes (for primer trimming)
TYPE="illumina" # choose between "illumina" or "MGI"

# SLURM account to bill
ACC_proj="" # your CSC project that will be used for billing in the format "project_1233"
