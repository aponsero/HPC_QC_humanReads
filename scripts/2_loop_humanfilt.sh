#!/bin/bash -l
#SBATCH --job-name=part6.3
#SBATCH --account=
#SBATCH --output=outputr%j.txt
#SBATCH --error=errors_%j.txt
#SBATCH --partition=small
#SBATCH --time=10:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --mem-per-cpu=1000


# load job configuration
cd $SLURM_SUBMIT_DIR
source ../config/config.sh

# load environment
source $CONDA/etc/profile.d/conda.sh
conda activate qc_human

# echo for log
echo "job started"; hostname; date

# go to folder
cd /scratch/project_2004512/my_data/MMP4 
OUT_DIR="/scratch/project_2004512/my_data/MMP4"

# set up loop
for fam in *_R1.fq.gz
do
	SAMPLE_ID=${fam%%_R1.fq.gz}
	PAIR1=$fam
	PAIR2="${SAMPLE_ID}_R2.fq.gz"


	BOWTIE_NAME="$OUT_DIR/${SAMPLE_ID}_host_removed_R%.fastq.gz"
	MET_NAME="$OUT_DIR/${SAMPLE_ID}_metrics.txt"
	SAM_NAME="$OUT_DIR/${SAMPLE_ID}_host.sam"
	MET_NAME="$OUT_DIR/${SAMPLE_ID}_hostmap.log"
	bowtie2 -p 8 -x $HUM_DB -1 $PAIR1 -2 $PAIR2 --un-conc-gz $BOWTIE_NAME 1> $SAM_NAME 2> $MET_NAME

	rm $SAM_NAME

	trim_galore --paired -o $OUT_DIR -a GCTCACAGAACGACATGGCTACGATCCGACTT -a2 TTGTCTTCCTAAGACCGCTTGGCCTCCGACTT --fastqc $OUT_DIR/${SAMPLE_ID}_host_removed_R1.fastq.gz $OUT_DIR/${SAMPLE_ID}_host_removed_R2.fastq.gz

done


# echo for log
echo "job done"; date
