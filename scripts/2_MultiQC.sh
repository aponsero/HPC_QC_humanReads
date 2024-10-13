#!/bin/bash -l
#SBATCH --job-name=multiqc
#SBATCH --output=errout/outputr%j.txt
#SBATCH --error=errout/errors_%j.txt
#SBATCH --partition=small
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1000


# load job configuration
cd $SLURM_SUBMIT_DIR
source config.sh

# load environment
export PATH="$TYKKY_MULTIQC:$PATH"

# echo for log
echo "job started"; hostname; date

# go to folder
rm -r $OUT_DIR/qc_host/tmp
cd $OUT_DIR/qc_host/logs

multiqc .

# echo for log
echo "job ended"; hostname; date
