#!/bin/bash

set -euo pipefail

BS=16
MSL=256
E=3
MODEL="biobert_v1.1_pubmed_pytorch/"
DATA="s800_tabs_small/"
LR="5e-5"

RUNTYPE="gpu"
RUNTIME="03:00:00"
#RUNTYPE="gputest"
#RUNTIME="00:15:00"

echo "Running with the following arguments"
echo "####################################"

echo "batch size:$BS"
echo "max seq length:$MSL"
echo "epochs:$E"
echo "model:$MODEL"
echo "data:$DATA"
echo "learningrate:$LR"
echo "runtype:$RUNTYPE"
echo "runtime:$RUNTIME"

echo -n "Please, submit a comment for this run:"
read comment

if [ -z "$comment" ]; then
 comment="generic"
fi

#for model outputdir
timenow=$(date +"%m-%d-%T")
output_dir="${comment}_${timenow}"

# replace sbatch settings
perl -p -i -e "s/#SBATCH --partition=(\w)+/#SBATCH --partition=$RUNTYPE/i" slurm-run.sh
perl -p -i -e "s/#SBATCH --time=[0-9:]+/#SBATCH --time=$RUNTIME/i" slurm-run.sh

command_str="sbatch slurm-run.sh -bs=$BS -msl=$MSL -e=$E -m=./models/$MODEL -d=./data/$DATA -od=./models/$output_dir -lr=$LR"

OUTPUT=$($command_str)

echo "$MODEL $DATA $BS $MSL $E -- $OUTPUT -- $output_dir -- $RUNTYPE $RUNTIME" >> RUNS.log
