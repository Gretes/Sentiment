from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.datasets import fetch_20newsgroups
from string import punctuation
from nltk.corpus import stopwords
from nltk import word_tokenize
from stemizer import getstems
import pandas as pd
import numpy as np

# TO DO list
# 1. Delete links from data
# 2. Think about hashtags
# 3. Do the analysis over a text which looks like a human output!!!

dat = pd.read_json("sample.json")
stop_words = pd.read_excel("stopwordstr.xlsx")
stop_words = stop_words['list'].values.tolist() + list(punctuation) # Stopwords and punctuation marks

vocabulary = set()

for text in dat['text'].values.tolist():
    words = word_tokenize(text)
    vocabulary.update(words)

vocabulary = list(vocabulary)

tfidf = TfidfVectorizer(stop_words=stop_words, tokenizer=word_tokenize, vocabulary=vocabulary)
tfidf.fit(dat['text'].values.tolist())
X     = tfidf.transform(dat['text'][0:10])
print X[0, tfidf.vocabulary_['alanadi']]
