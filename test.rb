require "sequel"

require_relative "lib/meme_collector/meme_collection"

CONFIG = {
  :query => "wall Trump", # "meme" will be automatically added to the query
  :from => Date.new(2016, 8, 1),
  :to => Date.new(2016, 8, 31)
}

# Generate new database
mc = MemeCollector::MemeCollection.generate "memes.db", CONFIG

# collect the first 10 memes per period
mc.collect!
