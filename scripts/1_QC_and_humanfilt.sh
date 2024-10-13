#!/bin/bash -l
#SBATCH --job-name=qc_humanfilt
#SBATCH --output=errout/outputr%j.txt
#SBATCH --error=errout/errors_%j.txt
#SBATCH --partition=small
#SBATCH --time=72:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=30
#SBATCH --mem-per-cpu=1000


# load job configuration
cd $SLURM_SUBMIT_DIR
source config.sh

# load environment
export PATH="$TYKKY_BOWTIE:$PATH"
export PATH="$TYKKY_QC:$PATH"

# echo for log
echo "job started"; hostname; date

# go to folder
cd $IN_DIR 

QC_OUT_DIR=$OUT_DIR/qc_host

if [[ ! -d "$QC_OUT_DIR" ]]; then
        mkdir -p $QC_OUT_DIR
fi

# read sample to process
export SAMPLE_ID=`head -n +${SLURM_ARRAY_TASK_ID} $IN_LIST | tail -n 1`

PAIR1="${SAMPLE_ID}${FOR}"
PAIR2="${SAMPLE_ID}${REV}"

# run Bowtie2 for human read removal
BOWTIE_NAME="$QC_OUT_DIR/${SAMPLE_ID}_host_removed_R%.fastq.gz"
SAM_NAME="$QC_OUT_DIR/${SAMPLE_ID}_host.sam"
MET_NAME="$QC_OUT_DIR/${SAMPLE_ID}_hostmap.log"

echo "bowtie2 -p 30 -x $HUM_DB -1 $PAIR1 -2 $PAIR2 --un-conc-gz $BOWTIE_NAME 1> $SAM_NAME 2> $MET_NAME"
bowtie2 -p 30 -x $HUM_DB -1 $PAIR1 -2 $PAIR2 --un-conc-gz $BOWTIE_NAME 1> $SAM_NAME 2> $MET_NAME

rm $SAM_NAME

# run trimgalore
mkdir -p $QC_OUT_DIR/tmp
export TMPDIR=$QC_OUT_DIR/tmp

TYPE_LOWER=$(echo "$TYPE" | tr '[:upper:]' '[:lower:]')

## paired-end MGI
if [[ "$TYPE_LOWER" == "mgi" ]]; then
        trim_galore --paired -o $QC_OUT_DIR -a GCTCACAGAACGACATGGCTACGATCCGACTT -a2 TTGTCTTCCTAAGACCGCTTGGCCTCCGACTT --fastqc --fastqc_args "-d $TMPDIR" $QC_OUT_DIR/${SAMPLE_ID}_host_removed_R1.fastq.gz $QC_OUT_DIR/${SAMPLE_ID}_host_removed_R2.fastq.gz
fi

## Paired-end Illumina
if [[ "$TYPE_LOWER" == "illumina" ]]; then
       trim_galore --paired -o $QC_OUT_DIR --fastqc $QC_OUT_DIR/${SAMPLE_ID}_host_removed_R1.fastq.gz $QC_OUT_DIR/${SAMPLE_ID}_host_removed_R2.fastq.gz 
fi

## cleaning and movind data
mkdir -p $QC_OUT_DIR/cleaned_reads
mkdir -p $QC_OUT_DIR/logs
mv $QC_OUT_DIR/${SAMPLE_ID}_host_removed_R1_val_1.fq.gz $QC_OUT_DIR/cleaned_reads
mv $QC_OUT_DIR/${SAMPLE_ID}_host_removed_R2_val_2.fq.gz $QC_OUT_DIR/cleaned_reads

mv ${SAMPLE_ID}_hostmap.log $QC_OUT_DIR/logs
mv ${SAMPLE_ID}_host_removed_R{1,2}.fastq.gz_trimming_report.txt $QC_OUT_DIR/logs
mv ${SAMPLE_ID}_host_removed_R{1,2}_val_{1,2}_fastqc.html $QC_OUT_DIR/logs 2>/dev/null
mv ${SAMPLE_ID}_host_removed_R{1,2}_val_{1,2}_fastqc.zip $QC_OUT_DIR/logs 2>/dev/null

rm $QC_OUT_DIR/${SAMPLE_ID}_host_removed_R1.fastq.gz
rm $QC_OUT_DIR/${SAMPLE_ID}_host_removed_R2.fastq.gz

# echo for log
echo "job done"; date
