#!/bin/bash

set -euo pipefail


echo "#############################################"
echo "##SETTING DIRS                             ##"

mkdir logs models data 

echo "#############################################"
echo "##MAKE VENV AND INSTALL IT                 ##"

module purge
module load python-data
python3 -m venv venv_transformers
source venv_transformers/bin/activate 
python3 -m pip install -r requirements.txt

# for jupyter installation
#python3 -m ipykernel install --user --name=venv_transformers


echo "#############################################"
echo "##GETTING MODEL                            ##"

#get model
bash get_biobert_model.sh

echo "#############################################"
echo """GETTING DATA                             ##"

bash get_s800_data.sh

echo "#############################################"
echo "##                  DONE                   ##"
echo "Now the following example command should work"
echo "sbatch slurm-run-2.sh -bs=8 -msl=256 -e=2 -m=./models/monologg/biobert_v1.1_pubmed -d=./data/s800/ -od=./models/s800_run_1"
