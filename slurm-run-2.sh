#!/bin/bash
#SBATCH --job-name=example
#SBATCH --account=Project_2001426
#SBATCH --partition=gpu
#SBATCH --time=02:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=8000
#SBATCH --gres=gpu:v100:1
#SBATCH -o logs/%j.out
#SBATCH -e logs/%j.err

#set -euo pipefail

rm -f logs/latest.out logs/latest.err
ln -s $SLURM_JOBID.out logs/latest.out
ln -s $SLURM_JOBID.err logs/latest.err

#module load gcc/8.3.0 cuda/10.1.168

module purge
module load python-data
source venv_transformers_/bin/activate
#python3 scripts/preprocess.py data/dev.txt.tmp $BERT_MODEL $MAX_LENGTH  > data/dev.txt

batch_size=32
learning_rate="0.001"
epochs=1
max_seq_length=128
output_dir="./models/s800_1"


for i in "$@"
do
case $i in
    -bs=*|--batch_size=*)
    batch_size="${i#*=}"
    shift # past argument=value
    ;;
    -lr=*|--learning_rate=*)
    learning_rate="${i#*=}"
    shift # past argument=value
    ;;
    -e=*|--epochs=*)
    epochs="${i#*=}"
    shift # past argument=value
    ;;
    -msl=*|--max_seq_length=*)
    max_seq_length="${i#*=}"
    shift # past argument=value
    ;;
    -m=*|--model=*)
    model="${i#*=}"
    shift # past argument=value
    ;;
    -lr=*|--learning_rate=*)
    learning_rate="${i#*=}"
    shift # past argument=value
    ;;
    -od=*|--output_dir=*)
    output_dir="${i#*=}"
    shift # past argument=value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument with no value
    ;;
    *)
          # unknown option
    ;;
esac
done


MAX_LENGTH=128
BERT_MODEL=bert-base-multilingual-cased
BERT_MODEL="monologg/biobert_v1.0_pubmed_pmc"
BERT_MODEL="monologg/biobert_v1.1_pubmed"
BERT_MODEL="./models/biobertTorch"
model="./models/biobertTorch"

#BERT_MODEL="./biobert/biobert_v1.0_pubmed_pmc"
OUTPUT_DIR="./models/s800_1"
BATCH_SIZE=32
NUM_EPOCHS=3
SAVE_STEPS=750
SEED=1
DATADIR="./data/" #s800SmallTrain/" #/conll/"
LABELS="${DATADIR}labels.txt"
LEARNING_RATE="0.001"

rm -rf $OUTPUT_DIR

echo "Sample from conll:"
head -5 $DATADIR"train.txt"
echo "Sample from labels:"
head -5 $LABELS

python3 run_tf_ner.py --data_dir $DATADIR \
--labels $LABELS \
--model_name_or_path $model \
--output_dir $output_dir \
--max_seq_length  $max_seq_length \
--num_train_epochs $epochs \
--per_device_train_batch_size $batch_size \
--save_steps $SAVE_STEPS \
--seed $SEED \
--do_train \
--do_eval \
--do_predict \
--overwrite_output_dir 
--from_pt True\

