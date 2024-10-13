#!/bin/bash -l

# load job configuration
source config/config.sh

#
#makes sure sample file is in the right place
#
if [[ ! -f "$IN_LIST" ]]; then
    echo "$IN_LIST does not exist. Please provide the path for a list of datasets to process. Job terminated."
    exit 1
fi

# get number of samples to process
export NUM_JOB=$(wc -l < "$IN_LIST")

# submit co_assemblies
echo "launching scripts/2_FasQC.sh as a job."

JOB_ID=`sbatch -a 1-$NUM_JOB scripts/2_MultiQC.sh`

