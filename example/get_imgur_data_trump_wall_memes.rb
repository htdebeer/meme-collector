require_relative "../lib/meme_collector/meme_collection"

# Imgur API has some restrictions. Notably, you can only do so many request an
# hour. Therefore, get the imgur data and wait a quarter of a minute after each
# request
meme_database = MemeCollector::MemeCollection.load "trump-wall-memes.db"
meme_database.delve_all!
