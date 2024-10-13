# Installation

This pipeline requires the installation of Bowtie2, Trim-galore! and MultiQC. The following steps details the installation in Puthi (CSC cluster system) using the Tykky containers.

## Bowtie2 installation

```
module load tykky
mkdir -p tykky/bowtie2_2.5.4
wrap-container -w /usr/local/bin docker://quay.io/biocontainers/bowtie2:2.5.4--h7071971_4 --prefix tykky/bowtie2_2.5.4
```
Then update the config/config.sh file to point the variable TYKKY_BOWTIE to the bin folder in the container:

```
TYKKY_BOWTIE="${YOUR_PATH}/tykky/bowtie2_2.5.4/bin"
```
Next you need to download the human genome of reference bowtie database

```
mkdir -p human_database
cd human_database
wget https://genome-idx.s3.amazonaws.com/bt/GRCh38_noalt_as.zip
unzip GRCh38_noalt_as.zip
rm GRCh38_noalt_as.zip
cd ..
```
Then update the HUM_DB variable to the bowtie reference database

```
HUM_DB="${YOUR_PATH}/human_database/GRCh38_noalt_as/GRCh38_noalt_as"
```

## TrimGalore! installation

```
module load tykky
mkdir -p tykky/trim-galore_0.6.10
wrap-container -w /usr/local/bin docker://quay.io/biocontainers/trim-galore:0.6.10--hdfd78af_0 --prefix tykky/trim-galore_0.6.10
```
Then update the config/config.sh file to point the variable TYKKY_QC to the bin folder in the container:

```
TYKKY_QC="${YOUR_PATH}/tykky/trim-galore_0.6.10/bin"
```

## Multi-QC installation

```
module load tykky
mkdir -p tykky/multiqc_1.25.1
wrap-container -w /usr/local/bin docker://quay.io/biocontainers/multiqc:1.25.1--pyhdfd78af_0 --prefix tykky/multiqc_1.25.1
```
Then update the config/config.sh file to point the variable TYKKY_MULTIQC to the bin folder in the container:

```
TYKKY_MULTIQC="${YOUR_PATH}/tykky/multiqc_1.25.1/bin"
```

 
