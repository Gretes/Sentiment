# -*- coding: utf-8 -*-
import pandas as pd
import re
from TurkishStemmer import TurkishStemmer
import nltk

# requirements
stemmer = TurkishStemmer()
sws = pd.read_excel("stopwordstr.xlsx")

# stemmer.stem("gözlükçülüğün")
# dat = pd.read_excel("hurriyetsample2.xlsx")
# sample = dat['content'][0]

# from stemizer import getstems
sws = sws['list'].values.tolist() # Stopwords

def getstems(text):
    # Input: text decoded with unicode decoder
    # Output: stemmed bag of words
    tokens = nltk.word_tokenize(text)
    tokens = [t for t in tokens if not t in sws]
    tokens = [re.sub(r"[^\w\s']",' ',t) for t in tokens]
    # tokens = [re.sub(r"[']",'',t) for t in tokens]
    tokens = [t for t in tokens if not re.search("[0-9]",t)]
    tokens = [t for t in tokens if not t is " "]
    tokens = [t.split() for t in tokens]
    tokens = sum(tokens,[])

    stemmed = [stemmer.stem(w) for w in tokens]

    bagofwords = []
    for s in stemmed:
        if re.search("[']",s):
            s = re.findall("^(.*)['].*",s)[0]
            bagofwords.append(s)
        else:
            bagofwords.append(s)

    bagofwords = [s.lower() for s in bagofwords]
    return bagofwords
