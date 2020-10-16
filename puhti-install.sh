#!/bin/bash

set -euo pipefail

echo "############################################"
echo "##INSTALLIG ON PUHTI                      ##"
echo "Skipping jupyter installation by default    "
echo "Uncomment lines in venv part to install it  "
sleep 5

# dirs should already exist, if not uncomment
echo "#############################################"
echo "##SETTING DIRS                             ##"

mkdir logs models data 

# it is a good idea to have a project specific name for venv
# in Puhti, because jupyter requires it
# puhti has tensorflow/2.0.0 but installation with it will
# run into problems
echo "#############################################"
echo "##MAKE VENV AND INSTALL IT                 ##"

echo "Loading python-data module"
module purge
module load python-data

echo "Setting virtual environmenti ( this can't a while )"
python3 -m venv venv_transformers_ner
source venv_transformers_ner/bin/activate 

echo "Installing requirements"
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
