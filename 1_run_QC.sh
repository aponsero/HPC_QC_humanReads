#/bin/bash -l

# load job configuration
source config.sh

#
#makes sure sample file is in the right place
#
if [[ ! -f "$IN_LIST" ]]; then
    echo "$IN_LIST does not exist. Please provide the path for a list of datasets to process. Job terminated."
    exit 1
fi

#
## some sanity checks
# 

# Check if TYPE is set properly
if [ -z "$TYPE" ]; then
    echo "Error: TYPE variable is not set." >&2
    exit 1
fi

TYPE_LOWER=$(echo "$TYPE" | tr '[:upper:]' '[:lower:]')

# Check if TYPE is either "mgi" or "illumina"
if [ "$TYPE_LOWER" != "mgi" ] && [ "$TYPE_LOWER" != "illumina" ]; then
    echo "Error: TYPE must be either 'MGI' or 'illumina'. Current value: $TYPE" >&2
    exit 1
fi

echo "Valid TYPE of metagenomes: $TYPE"

# check is ACC_proj is set properly
if [ -z "$ACC_proj" ]; then
    echo "Error: ACC_proj variable is not set." >&2
    exit 1
fi

# get number of samples to process
export NUM_JOB=$(wc -l < "$IN_LIST")

# submit co_assemblies
echo "launching scripts/1_QC_and_human.sh as a job."

JOB_ID=`sbatch --account=$ACC_proj -a 1-$NUM_JOB scripts/1_QC_and_humanfilt.sh`

