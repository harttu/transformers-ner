#!/bin/bash

set -euo pipefail

# dirs should already exist, if not uncomment
#echo "#############################################"
#echo "##SETTING DIRS                             ##"

#mkdir logs models data 

# it is a good idea to have a project specific name for venv
# in Puhti, because jupyter requires it
# puhti has tensorflow/2.0.0 but installation with it will
# run into problems
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

#get model monologg/biobert model
bash get_biobert_model.sh

echo "#############################################"
echo """GETTING DATA                             ##"

# get s800 revision 6 data, from spyysalo github repo
bash get_s800_data.sh

echo "#############################################"
echo "##                  DONE                   ##"
echo "Now the following example command should work"
echo "sbatch slurm-run.sh -bs=8 -msl=256 -e=2 -m=./models/monologg/biobert_v1.1_pubmed -d=./data/s800/ -od=./models/s800_run_1"