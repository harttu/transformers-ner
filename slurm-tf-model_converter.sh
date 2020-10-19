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

module purge
module load python-data
source venv_transformers_ner/bin/activate

module load gcc/8.3.0 cuda/10.1.168

python3 convert_tf_checkpoint_to_pytorch.py --tf_checkpoint_path models/biobert_v1.1_pubmed/bert_model.ckpt --bert_config_file models/biobert_v1.1_pubmed/bert_config.json --pytorch_dump_path models/tmpDump.bin
#srun myprog <options>
