#!/bin/bash

set -euo pipefail

ITER=(1 2 3)
BS=(4 8 16 32)
MSL=(128 256 320 440 512)
E=(3)
MODEL=("biobert_v1.1_pubmed_pytorch/")
DATA="s800/"
LR=("5e-5")

RUNTYPE="gpu"
RUNTIME="03:00:00"
#RUNTYPE="gputest"
#RUNTIME="00:15:00"

echo "Running with the following arguments"
echo "####################################"

echo "batch size:${BS[*]}"
echo "max seq length:${MSL[*]}"
echo "epochs:${E[*]}"
echo "learningrate:${LR[*]}"
echo "model:${MODEL[*]}"
echo "--"
echo "data:$DATA"
echo "runtype:$RUNTYPE"
echo "runtime:$RUNTIME"

echo -n "Please, submit a name for this gridrun:"
read name

if [ -z "$name" ]; then
 echo "No name given"
 exit 1
fi

FILE="${name}.log"

if [ -f "$FILE" ]; then
	echo "A file by name $FILE already exists. If you want a grid run by the same name, delete the file first"
 	exit 1
fi 

if [ -f cancelMostRecentJobs.sh ]; then
  rm cancelMostRecentJobs.sh
  chmod +x cancelMostRecentJobs.sh 
fi 

#for model outputdir
for m in "${MODEL[@]}"
do
	for bs in "${BS[@]}"
	do
		for msl in "${MSL[@]}"
		do
			for e in "${E[@]}"
			do

				echo "MODEL: $m DATA: $DATA BS: $bs MSL: $msl E: $e N: $name " >> "$FILE"
				for i in "${ITER[@]}"
				do
					timenow=$(date +"%m-%d-%T")
					output_dir="${name}_${m}_${bs}_${msl}_${e}_${i}"

					# replace sbatch settings
					perl -p -i -e "s/#SBATCH --job-name=[A-Za-z0-9]+/#SBATCH --job-name=$name/i" slurm-run.sh
					perl -p -i -e "s/#SBATCH --partition=(\w)+/#SBATCH --partition=$RUNTYPE/i" slurm-run.sh
					perl -p -i -e "s/#SBATCH --time=[0-9:]+/#SBATCH --time=$RUNTIME/i" slurm-run.sh

					command_str="sbatch slurm-run.sh -bs=$bs -msl=$msl -e=$e -m=./models/$m -d=./data/$DATA -od=./models/$output_dir -lr=$LR --grid=\"true\""

					OUTPUT=$($command_str)
					#OUTPUT="Submitted a batchjob 123"
					ID=$(awk '{ sub("Submitted batch job ","");  print $FN }' <<< $OUTPUT)
					echo "scancel $ID" >> cancelMostRecentJobs.sh

					echo $ID >> $FILE
				done #ITER
			done #EPOCH
		done #MAX SEQ LEN
	done #BATCH SIZE
done # MODEL


# revert to default values
perl -p -i -e "s/#SBATCH --job-name=[A-Za-z0-9]+/#SBATCH --job-name=example/i" slurm-run.sh
perl -p -i -e "s/#SBATCH --partition=(\w)+/#SBATCH --partition=gputest/i" slurm-run.sh
perl -p -i -e "s/#SBATCH --time=[0-9:]+/#SBATCH --time=00:15:00/i" slurm-run.sh
