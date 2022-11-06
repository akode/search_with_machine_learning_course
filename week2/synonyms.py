import fasttext

model = fasttext.load_model("./week2/model.bin")

def find_synonyms(word, k=20, thrsh=0.75):
    synonyms = list(map(lambda x: x[1], filter(lambda x: x[0]>thrsh, model.get_nearest_neighbors(word, k=k))))
    return synonyms
       

if __name__ == "__main__":
    
    thrsh = 0.75
    k = 20
    with open("/workspace/datasets/fasttext/top_words.txt") as file, open("/workspace/datasets/fasttext/synonyms.csv", "w") as output:
        for line in file:
            word = line.strip()
            synonyms = find_synonyms(word, k=k, thrsh=thrsh)
            new_line = ",".join([word]+synonyms)
            output.write(new_line + "\n")
    
