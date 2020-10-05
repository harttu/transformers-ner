#!/bin/bash
#SBATCH --job-name=example
#SBATCH --account=Project_2001426
#SBATCH --partition=gputest
#SBATCH --time=00:15:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=8000
#SBATCH --gres=gpu:v100:1
#SBATCH -o logs/%j.out
#SBATCH -e logs/%j.err

rm -f logs/latest.out logs/latest.err
ln -s $SLURM_JOBID.out logs/latest.out
ln -s $SLURM_JOBID.err logs/latest.err

module load gcc/8.3.0 cuda/10.1.168


source venv/bin/activate
#python3 scripts/preprocess.py data/dev.txt.tmp $BERT_MODEL $MAX_LENGTH  > data/dev.txt
echo "dollar1 is $1"

MAX_LENGTH=128
BERT_MODEL=bert-base-multilingual-cased

OUTPUT_DIR=s800_1
BATCH_SIZE=32
NUM_EPOCHS=3
SAVE_STEPS=750
SEED=1

python3 run_tf_ner.py --data_dir ./data/ \
--labels ./s800/conll/labels.txt \
--model_name_or_path $BERT_MODEL \
--output_dir $OUTPUT_DIR \
--max_seq_length  $MAX_LENGTH \
--num_train_epochs $NUM_EPOCHS \
--per_device_train_batch_size $BATCH_SIZE \
--save_steps $SAVE_STEPS \
--seed $SEED \
--do_train \
--do_eval \
--do_predict
#srun myprog <options>
