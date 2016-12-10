#!/usr/bin/env ruby
require "date"
require "ruby_google_search"

JANUARY = 1
DECEMBER = 12

results = nil

# Setup the search engine to look for images with search string "wall meme"
# It is assumed that your Google API key and Google Custom Search ID are in
# the environment
engine = RubyGoogleSearch::Engine.new ENV["GOOGLE_API_KEY"], ENV["GOOGLE_SEARCH_ENGINE_ID"]
engine.setup do
  query "wall meme"
  find_only_images
end

# For each month in 2016, find the first 10 images
JANUARY.upto(DECEMBER) do |month|
  month_results = engine.search do
    from Date.new(2016, month, 1)
    to Date.new(2016, month, 1)
  end

  if results.nil?
    results = month_results
  else
    results.merge month_results
  end
end

# Save the results to a file
File.open("wall-meme-results-2016-jan-dec.yaml", "w") {|f| f.write(results.to_yaml)}

# Download each image file to the current directory
results.each do |item|
  item.download
end
