module purge
module load tensorflow/2.2-hvd
python -m venv tf2.2-transformers3.4
source tf2.2-transformers3.4/bin/activate
python -m pip install transformers==3.4 
python -m pip install torch
python -m pip install seqeval
python -m pip install conllu
