from collections import defaultdict
from pymongo import MongoClient
from pprint import pprint
import json

client = MongoClient('mongodb://veli:kamil7insan@ds237445.mlab.com:37445/heroku_wzpvdrhs')
db = client['heroku_wzpvdrhs']
collection = db.bein1


sample = open("bein1.json",'w')
sample.write("[")
for post in collection.find():
    tweet_data = defaultdict()
    tweet_data['name'] = post['user']['screen_name']
    tweet_data['location'] = post['user']['location']
    tweet_data['tweet'] = post['text']
    tweet_data['datetime'] = post['created_at']
    tweet_data['reply_screen_name'] = post['in_reply_to_screen_name']
    tweet_data['hashtags'] = '|'.join([h['text'] for h in post['entities']['hashtags']])
    tweet_data['user_mentions'] = '|'.join([h['screen_name'] for h in post['entities']['user_mentions']])
    tweet_data['follower_count'] = post['user']['followers_count']
    try:
        tweet_data['retweeted_by'] = post['retweeted_status']['user']['screen_name']
        tweet_data['retweet_count'] = post['retweeted_status']['retweet_count']
    except:
        tweet_data['retweeted_by'] = None
        tweet_data['retweet_count'] = None
    print(tweet_data)
    tweet_data = json.dumps(tweet_data)
    print(tweet_data)
    json.dump(tweet_data,sample)
    json.dump(",\n")


sample.write("]")
sample.close()
