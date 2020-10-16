# transformers-ner
Fork fro Huggingface transformers example

## Installing on Puhti
The following should work at least for running slurm jobs. Interactive session might require something extra.
```bash
bash puhti-install.sh
```
## Testing
The following should do after running the install-script
```bash
sbatch slurm-run.sh -bs=8 -msl=256 -e=2 -m=./models/monologg/biobert_v1.1_pubmed -d=./data/s800/ -od=./models/s800_run_1
```

## Some notes
1. There is a bug in initializing the model. If .bin is present in the folder containing the model transformers will use that as a model( that is why troch is required even when working with TF )
2. Using module load tensorflow, is know to have some issues. 

## TODO
1. Modify the script to use tab as separator
2. Take os.path.join in use whenever possible
3. Fix bool - bug in trainer part
4. learning rate from as a parameter ( command line )


