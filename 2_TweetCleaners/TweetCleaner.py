from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.datasets import fetch_20newsgroups
from stemizer import getstems
import pandas as pd
import numpy as np


# TO DO list
# 1. Delete links from data
# 2. Think about hashtags
# 3. Do the analysis over a text which looks like a human output!!!
twenty = fetch_20newsgroups()


vectorizer = TfidfVectorizer()
X = vectorizer.fit_transform(twenty.data)
indices = np.argsort(vectorizer.idf_)[::-1]
features = vectorizer.get_feature_names()
top_n = 2
top_features = [features[i] for i in indices[:top_n]]
print top_features




dat = pd.read_json("sample.json")
vectorizer = TfidfVectorizer()
X = vectorizer.fit_transform(dat['text'])
indices = np.argsort(vectorizer.idf_)[::-1]
features = vectorizer.get_feature_names()
top_n = 2
top_features = [features[i] for i in indices[:top_n]]
print top_features
