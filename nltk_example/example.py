# -*- coding: utf-8 -*-
import pandas as pd
import re
from TurkishStemmer import TurkishStemmer
stemmer = TurkishStemmer()
stemmer.stem("gözlükçülüğün")

dat = pd.read_excel("hurriyetsample2.xlsx")
sws = pd.read_excel("stopwordstr.xlsx")

sws = sws['a'].values.tolist()
sample = dat['content'][0]

tokens = nltk.word_tokenize(sample)
tokens = [t for t in tokens if not t in sws]
tokens = [re.sub(r"[^\w\s']",' ',t) for t in tokens]
# tokens = [re.sub(r"[']",'',t) for t in tokens]
tokens = [t for t in tokens if not re.search("[0-9]",t)]
tokens = [t for t in tokens if not t is " "]
tokens = [t.split() for t in tokens]
tokens = sum(tokens,[])

stemmed = [stemmer.stem(w) for w in tokens]

stemmed2 = []
for s in stemmed:
    if re.search("[']",s):
        s = re.findall("^(.*)['].*",s)[0]
        stemmed2.append(s)
    else:
        stemmed2.append(s)

stemmed2 = [s.lower() for s in stemmed2]
