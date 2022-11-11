fasttext = /home/gitpod/fastText-0.9.2/fasttext

w3_dataprep:
	python week3/create_labeled_queries.py --min_queries 100

salt:
	seq 99999 > salt.txt

w3_shuffle:
	shuf /workspace/datasets/fasttext/labeled_queries.txt  > /workspace/datasets/fasttext/labeled_queries_shuffled.txt
	head -50000 /workspace/datasets/fasttext/labeled_queries_shuffled.txt > /workspace/datasets/fasttext/labeled_queries_training.txt
	head -10000 /workspace/datasets/fasttext/labeled_queries_shuffled.txt > /workspace/datasets/fasttext/labeled_queries_test.txt

w3_train:
	$(fasttext) supervised -input /workspace/datasets/fasttext/labeled_queries_training.txt -output /workspace/datasets/fasttext/query_classification -epoch 10 -lr 0.5 -wordNgrams 2
	$(fasttext) test /workspace/datasets/fasttext/query_classification.bin /workspace/datasets/fasttext/labeled_queries_test.txt

w3: salt w3_dataprep w3_shuffle w3_train