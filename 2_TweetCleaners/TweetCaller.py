from pymongo import MongoClient
from pprint import pprint
import pandas as pd

client = MongoClient('mongodb://veli:kamil7insan@ds237445.mlab.com:37445/heroku_wzpvdrhs')
db = client['heroku_wzpvdrhs']
collection = db.thy

# dili turkce olan post sayisi
# print(collection.find({"lang": "tr"}).count())


# Regex query for turkcell
query = { "text": { "$regex": "/.*kcell.*/"} }
posts = pd.DataFrame([p for p in collection.find(query).limit(100)])

# write to json
posts.to_json("sample.json")
