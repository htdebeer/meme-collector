require_relative "../lib/meme_collector/meme_collection"

# There are 73 periods in the database, so, given the Google Custom Search
# API's limit of 100 request per day (for freeskaters like us), only one page
# of results per period can be collected per day
meme_database = MemeCollector::MemeCollection.load "trump-wall-memes-per-week.db"
meme_database.collect!
