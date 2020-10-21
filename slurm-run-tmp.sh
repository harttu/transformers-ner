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

set -euo pipefail

#module load gcc/8.3.0 cuda/10.1.168

module purge
module load python-data
module load gcc/8.3.0 cuda/10.1.168
source venv_transformers_ner/bin/activate

rm -f latest.out latest.err
ln -s logs/$SLURM_JOBID.out latest.out
ln -s logs/$SLURM_JOBID.err latest.err

echo "Running python program"
python3 cudaTest.py
nvidia-smi

