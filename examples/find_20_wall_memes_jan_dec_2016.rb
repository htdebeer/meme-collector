#!/usr/bin/env ruby
require "yaml"
require "date"
require "ruby_google_search"

JANUARY = 1
NOVEMBER = 2

results = []

# Setup the search engine to look for images with search string "wall meme"
# It is assumed that your Google API key and Google Custom Search ID are in
# the environment
engine = RubyGoogleSearch::Engine.new ENV["GOOGLE_API_KEY"], ENV["GOOGLE_SEARCH_ENGINE_ID"]
engine.setup do
  query "wall meme"
  find_only_images
end

# For each month in 2016, find the first 20 images (if there are that many)
JANUARY.upto(NOVEMBER) do |month|
  engine.search do
    from Date.new(2016, month, 1)
    to Date.new(2016, month + 1, 1)
  end
    
  results << engine.next_page
  
  engine.restart
end

# Save the results to a file
File.open("wall-meme-results-2016-jan-dec-20.yaml", "w") do |file|
  output = results.map {|r| r.to_h}
  file.write YAML.dump(output)
end
