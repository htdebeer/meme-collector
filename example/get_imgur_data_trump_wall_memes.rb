require_relative "../lib/meme_collector/meme_collection"

# Imgur API has some restrictions. Notably, you can only do so many request an
# hour. Therefore, instead of getting imgur data of all collected memes, get
# them for 10
meme_database = MemeCollector::MemeCollection.load "trump-wall-memes.db"
meme_database.delve! 100, 30
