# transformers-ner
Fork fro Huggingface transformers example

## Some notes
1. There is a bug in initializing the model. If .bin is present in the folder containing the model transformers will use that as a model( that is why troch is required even when working with TF )
2. Using module load tensorflow, is know to have some issues. 

## TODO
1. Modify the script to use tab as separator
2. Take os.path.join in use whenever possible
3. Fix bool - bug in trainer part
4. learning rate from as a parameter ( command line )

## Installing on Puhti
The following should work at least for running slurm jobs. Interactive session might require something extra
```bash
module purge
module load python-data
python3 -m venv venv_transformers
source venv_transformers/bin/activate 
python3 -m pip install -r requirements.txt
#python3 -m pip install seqeval transformers=3.3.1 conllu tensorflow ipykernel
python3 -m ipykernel install --user --name=venv_transformers
```
