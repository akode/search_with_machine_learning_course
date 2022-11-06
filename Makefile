fasttext = "/home/gitpod/fastText-0.9.2/fasttext"
datapath = "/workspace/datasets/fasttext"

random_salt:
	seq 99999 > salt.txt

w2_cat:
	python week2/createContentTrainingData.py --output $(datapath)/labeled_products.txt --min_products 500

w2_shuffle:
	shuf /workspace/datasets/fasttext/labeled_products.txt --random-source=salt.txt > /workspace/datasets/fasttext/shuffled_labeled_products.txt

w2_clean:
	cat /workspace/datasets/fasttext/shuffled_labeled_products.txt |sed -e "s/\([.\!?,'/()]\)/ \1 /g" | tr "[:upper:]" "[:lower:]" | sed "s/[^[:alnum:]_]/ /g" | tr -s ' ' > /workspace/datasets/fasttext/normalized_labeled_products.txt

w2_split:
	head -10000 /workspace/datasets/fasttext/normalized_labeled_products.txt > /workspace/datasets/fasttext/training_data.txt
	tail -10000 /workspace/datasets/fasttext/normalized_labeled_products.txt > /workspace/datasets/fasttext/test_data.txt

w2_train:
	$(fasttext) supervised -input /workspace/datasets/fasttext/training_data.txt -output week2/model -lr 1.0 -epoch 25 -wordNgrams 2
	$(fasttext) test week2/model.bin /workspace/datasets/fasttext/test_data.txt	

w2_skipgram:
	cut -d' ' -f2- $(datapath)/shuffled_labeled_products.txt > $(datapath)/titles.txt
	cat $(datapath)/titles.txt | sed -e "s/\([.\!?,'/()]\)/ \1 /g" | tr "[:upper:]" "[:lower:]" | sed "s/[^[:alnum:]]/ /g" | tr -s ' ' > $(datapath)/normalized_titles.txt
	$(fasttext) skipgram -minCount 20 -epochs 25 -input $(datapath)/normalized_titles.txt -output $(datapath)/title_model

w2: w2_cat w2_shuffle w2_clean w2_split w2_train w2_skipgram

