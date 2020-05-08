#!/usr/bin/env bash

NAME="aclImdbSimple_pretrained_mixed"
OUT="temp/$NAME"

mkdir -p ${OUT}

# Preprocess
# For Semi-supervised experiments, replacing dev with test doesn't result in much difference
python preprocess.py --corpus aclImdb_tok --output ${OUT}/data --aclImdb_tok_dev "aclImdb_tok/test.txt"

# Create pre-trained word embeddings
python w2v.py --input ${OUT}/data --save_data "demo" --embeddings "vectors_aclImdb.txt"

# Train the model
python main.py --corpus aclImdb_tok --model LSTMEncoder --debug \
--multi_gpu --input ${OUT}/data --output_path ${OUT}/model --exp_name "aclImdbSimple_pretrained_mixed" \
--use_pretrained_embeddings --nepoch_no_imprv 20 --timedistributed --d_hidden 512 --nepochs 50 \
--optim adam --beta1 0.0 --beta2 0.9998 \
--inc_unlabeled_loss --wbatchsize 3000 --wbatchsize_unlabel 3000 --lambda_at 1.0 --lambda_vat 1.0 
