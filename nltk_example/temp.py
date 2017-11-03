# -*- coding: utf-8 -*-
import pandas as pd
from TurkishStemmer import TurkishStemmer
stemmer = TurkishStemmer()
stemmer.stem("gözlükçülüğün")

dat = pd.read_excel("hurriyetsample2.xlsx")
sws = pd.read_excel("stopwordstr.xlsx")
sample = dat['content'][0]

nltk.word_tokenize(sample)