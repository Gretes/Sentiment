from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.feature_extraction.text import CountVectorizer
from pymongo import MongoClient
from pprint import pprint
import pandas as pd
from stemizer import getstems
from string import punctuation
from nltk import word_tokenize
import math
from collections import defaultdict

client = MongoClient('mongodb://veli:kamil7insan@ds237445.mlab.com:37445/heroku_wzpvdrhs')
db = client['heroku_wzpvdrhs']
collection = db.bein1

# dili turkce olan post sayisi
# print(collection.find({"lang": "tr"}).count())


# Regex query for turkcell
#query = { "text": { "$regex": "/.*kcell.*/"} }
posts = pd.DataFrame([p for p in collection.find()])

# write to json
posts.to_json("sample.json")

data = []
counter = 1
datname = 1
for post in collection.find():
    data.append(post)
    if counter % 500 == 0:
        pd.DataFrame(data).to_json('beindata' + str(datname) + ".json")
        print(counter)
        counter += 1
        datname += 1
        data = []
    else:
        counter += 1


        with open('data' + datname + '.txt', 'w') as outfile:
            json.dumps(data, outfile)
tweets = posts['text']
# [getstems(t) for t in tweets]

# stop_words  = pd.read_excel("stopwordstr.xlsx").values.tolist()
# stop_words = stop_words + list(punctuation)

bagofwords = [getstems(t) for t in tweets]
vocabulary = sum(bagofwords,[])
vocabulary = list(set(vocabulary))

stemmedtweets = [" ".join(b) for b in bagofwords]
DOCUMENTS_COUNT = len(stemmedtweets)
word_idf = defaultdict(lambda: 0)

for words in bagofwords:
    words = set(words)
    for word in words:
        word_idf[word] += 1
        for word in vocabulary:
            word_idf[word] = math.log(DOCUMENTS_COUNT / float(1 + word_idf[word]))

#count_vect = CountVectorizer()
#X_train_counts = count_vect.fit_transform(stemmedtweets)
#X_train_counts.shape
#tf_transformer = TfidfTransformer(use_idf=False).fit(X_train_counts)
#X_train_tf = tf_transformer.transform(X_train_counts)
#keyword=sum(X_train_tf)

tfidf.fit(stemmedtweets[5])
# Transform a document into TfIdf coordinates
X = tfidf.transform(stemmedtweets[3:2002])
# Check out some frequencies
print(X[0, tfidf.vocabulary_['thy']])                   # 0.0562524229373

for t in tweets:
    print(t)
