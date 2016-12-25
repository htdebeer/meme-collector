require_relative "../lib/meme_collector/meme_collection"

CONFIG = {
  :query => "Trump wall", # "meme" will be automatically added to the query
  :from => Date.new(2015, 6, 16),
  :to => Date.new(2017, 1, 20)
}

# Generate new database
MemeCollector::MemeCollection.generate "trump-wall-memes.db", CONFIG
