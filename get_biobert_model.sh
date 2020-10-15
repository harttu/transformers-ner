#!/bin/bash

set -euo pipefail

model="monologg/biobert_v1.1_pubmed"
target_dir="models/$model"

if [ ! -d "$target_dir" ]; then
	#targer_dir=models/biobertTorch
	mkdir -p "$target_dir" # -p for creating parents
	## for pytorh model these should be the files
	files=(https://s3.amazonaws.com/models.huggingface.co/bert/${model}/config.json \
	https://cdn.huggingface.co/${model}/pytorch_model.bin \
	https://cdn.huggingface.co/${model}/special_tokens_map.json \
	https://cdn.huggingface.co/${model}/tokenizer_config.json \
	https://cdn.huggingface.co/${model}/vocab.txt)

	for url in "${files[@]}"
	do
		eval "wget $url --directory-prefix=$target_dir"
	done
	else
		echo "Model DIR exists"
fi
