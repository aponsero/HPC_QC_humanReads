#!/bin/bash -l
#SBATCH --job-name=qc_humanfilt
#SBATCH --account=
#SBATCH --output=errout/outputr%j.txt
#SBATCH --error=errout/errors_%j.txt
#SBATCH --partition=small
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --mem-per-cpu=1000


# load job configuration
cd $SLURM_SUBMIT_DIR
source config/config.sh

# load environment
source $CONDA/etc/profile.d/conda.sh
conda activate qc_human

# echo for log
echo "job started"; hostname; date

# go to folder
cd $IN_DIR 
mkdir $OUT_DIR

# read sample to process
export SMPLE=`head -n +${SLURM_ARRAY_TASK_ID} $IN_LIST | tail -n 1`
IFS=',' read -ra my_array <<< $SMPLE

SAMPLE_ID=${my_array[0]}
PAIR1=${my_array[1]}
PAIR2=${my_array[2]}


# run Bowtie2 for human read removal
BOWTIE_NAME="$OUT_DIR/${SAMPLE_ID}_host_removed_R%.fastq.gz"
SAM_NAME="$OUT_DIR/${SAMPLE_ID}_host.sam"
MET_NAME="$OUT_DIR/${SAMPLE_ID}_hostmap.log"
#echo "bowtie2 -p 8 -x $HUM_DB -1 $PAIR1 -2 $PAIR2 --un-conc-gz $BOWTIE_NAME 1> $SAM_NAME 2> $MET_NAME"
#bowtie2 -p 8 -x $HUM_DB -1 $PAIR1 -2 $PAIR2 --un-conc-gz $BOWTIE_NAME 1> $SAM_NAME 2> $MET_NAME

rm $SAM_NAME

# run QC
echo "trim_galore --paired -o $OUT_DIR -a GCTCACAGAACGACATGGCTACGATCCGACTT -a2 TTGTCTTCCTAAGACCGCTTGGCCTCCGACTT --fastqc $OUT_DIR/${SAMPLE_ID}_host_removed_R1.fastq.gz $OUT_DIR/${SAMPLE_ID}_host_removed_R2.fastq.gz"

## unique pair sequencing MGI
#trim_galore -o $OUT_DIR -a GCTCACAGAACGACATGGCTACGATCCGACTT --fastqc $OUT_DIR/${SAMPLE_ID}_host_removed_R1.fastq.gz

## paired-end MGI
trim_galore --paired -o $OUT_DIR -a GCTCACAGAACGACATGGCTACGATCCGACTT -a2 TTGTCTTCCTAAGACCGCTTGGCCTCCGACTT --fastqc $OUT_DIR/${SAMPLE_ID}_host_removed_R1.fastq.gz $OUT_DIR/${SAMPLE_ID}_host_removed_R2.fastq.gz

## Paired-end Illumina
#trim_galore --paired -o $OUT_DIR --fastqc $OUT_DIR/${SAMPLE_ID}_host_removed_R1.fastq.gz $OUT_DIR/${SAMPLE_ID}_host_removed_R2.fastq.gz

# echo for log
echo "job done"; date
