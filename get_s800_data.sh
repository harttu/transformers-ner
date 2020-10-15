#!/bin/bash

set -euo pipefail

datamodel="s800"
target_dir="data/$datamodel"

if [ ! -d "$target_dir" ]; then
	#targer_dir=models/biobertTorch
	mkdir -p "$target_dir" # -p for creating parents
	cd "data"
	git clone https://github.com/spyysalo/s800-revision-data.git
	git clone https://github.com/spyysalo/s800.git s800-tools
	mkdir s800-tools/standoff
	cp s800-revision-data/revised-standoff/*.{txt,ann} s800-tools/standoff/
	cd s800-tools/
	./split_s800.sh
	mkdir conll
	git clone https://github.com/spyysalo/standoff2conll.git
	for i in train devel test; do python3 standoff2conll/standoff2conll.py split-standoff/$i > conll/$i.tsv; done
	mv conll/devel.tsv conll/dev.tsv
	perl -p -i -e 's/[BI]-(Out-of-scope|Order|Class|Phylum|Kingdom)/O/' conll/*.tsv 
        
        ### If the model is using tab as separators, skip the rest
        expand -t 1 conll/train.tsv > ../s800/train.txt
        expand -t 1 conll/test.tsv > ../s800/test.txt
        expand -t 1 conll/dev.tsv > ../s800/dev.txt    
        cd ../s800
        awk '{print $2}' * | sort | uniq > labels.txt
else
	echo "$target_dir already exists"
fi
