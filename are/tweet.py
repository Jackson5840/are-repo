import tweepy

def create_tweet(tweet_link):
    consumer_key = 'y6vLTNiRFwNpcUd4Rk6ntVDo3'
    consumer_secret = 'FdSETIgoxXIGkcJseOvgIGQcyZtUr7eFqzdoUB8I9WciJSWFaB'
    access_token = '223121018-2YOxlA3Babx1pqbhtyOHsEYA7l1siy6VenVr46w6'
    access_token_secret = 'wfrCDCrkZfu87VbpWH4rcx2OwSi4YhW37ug2oHzisOQ2L'

    auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)

    api = tweepy.API(auth)

    message = "New publication from the http://NeuroMorpho.Org team: " + tweet_link
    api.update_status(status=message)
