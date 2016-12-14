# Copyright 2016, Huub de Beer <Huub@heerdebeer.org>
#
# This file is part of ruby_google_search.
#
# ruby_google_search is free software: you can redistribute it and/or modify it under the
# terms of the GNU Lesser General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# ruby_google_search is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more
# details.
#
# You should have received a copy of the GNU Lesser General Public License along with
# Foobar.  If not, see <http://www.gnu.org/licenses/>.
require "uri"
require "net/http"
require "json"
require "date"

require_relative "./results.rb"
require_relative "./api_error.rb"

module RubyGoogleSearch
  class Engine

    BASE_URL = "https://www.googleapis.com/customsearch/v1"
    FORMAT = "%Y%m%d"

    attr_reader :parameters

    ## 
    # Create a new Google Custom Search engine. The two optional parameters
    # api_key and search_engine_id
    # default to ENV["GOOGLE_API_KEY"] and ENV["GOOGLE_SEARCH_ENGINE_ID"]
    # respectively.
    def initialize api_key = ENV["GOOGLE_API_KEY"], search_engine_id = ENV["GOOGLE_SEARCH_ENGINE_ID"]
      @results = nil
      @parameters = {
        "key" => api_key,
        "cx" => search_engine_id
      }
      @from = nil
      @to = nil
      @start_index = 1
    end

    def self.load hash
      engine = Engine.new
      hash["parameter"].each_pair {|key, value| engine.parameter key, value}
      engine.from hash["from"]
      engine.to hash["to"]
      engine.start_index hash["start_index"]
      engine
    end

    ##
    # Setup the search engine with a block. This allows you to use the various
    # configuration options in a Rubyesq manner. For example:
    #   
    #     engine = GoogleCustomSearchEngine.new
    #     engine.setup do
    #       from Date.new(2015, 8, 7)
    #       to Date.new(2015, 8, 10)
    #       find_only_images
    #     end
    #
    # Returns self to allow chaining.
    def setup &block
      instance_eval(&block)
      self
    end

    ##
    # Run the engine to search. If a block is given, it is interpreted as a
    # setup block. The engine does not run if the search query is not defined or
    # the empty string.
    #
    # Returns a GoogleCustomSearchResults object with the results of the search
    def search &block
      setup(&block) if block_given?
      run
    end


    ## 
    # Does this engine have a next page with results?
    def has_next_page?
      not @results.nil? and (@start_index + 10) < @results.total_results
    end

    ##
    # Run the engine again with the same settings, but get the next 10 results
    def next_page
      if has_next_page?
        start @start_index + 10
        @results.merge! run
      end

      @results
    end

    ##
    # Set the search string
    def query string
      @parameters["q"] = string
      self
    end

    ##
    # Setup the engine to only search for images
    def find_only_images
      @parameters["searchType"] = "image"
      self
    end

    ##
    # Setup the engine to search for any type of thing, This is the default.
    def find_everything
      @parameters.delete "searchType"
      self
    end

    ##
    # Setup the engine to search in a period. If no `to_date` is supplied, today
    # is used instead.
    def period from_date, to_date = Date.today
      from from_date
      to to_date
      self
    end

    ##
    # Setup the engine to search from a certain date to today (or an end date
    # set using the `period` or `to` methods.
    def from date
      @from = date
      @to = Date.today if @to.nil?
      sort_parameter
      self
    end

    ##
    # Setup the engine to search until a certain date. If the from date is not
    # set via the `period` or `from` methods, the from date is set to one year
    # prior to the to date.
    def to date
      @to = date
      @from = @to.prev_year if @from.nil?
      sort_parameter
      self
    end

    ## 
    # Setup the engine to search on the site with url only
    def site url
      @parameters["siteSearch"] = url
      self
    end

    ##
    # Setup the engine to return 10 results starting from index
    def start index
      @start_index = index
      @parameters["start"] = index
      self
    end

    ##
    # Setup the engine to return the first 10 items
    def restart
      @start_index = 1
      @parameters.delete "start"
      self
    end

    ##
    # Setup the engine with any parameter
    def parameter key, value
      @parameters[key] = value
      self
    end

    def to_uri
      uri = URI(BASE_URL)
      uri.query = URI.encode_www_form(@parameters)
      uri
    end

    def to_h
      {
        "from" => @from,
        "to" => @to,
        "start_index" => @start_index,
        "parameters" => @parameters
      }
    end

    private 

    def run
      uri = to_uri 
      response = Net::HTTP.get_response(uri)
      if response.is_a? Net::HTTPSuccess
        @results = RubyGoogleSearch::Results.from_json self, response.body
        @results
      else 
        raise RubyGoogleSearch::APIError, "Problem running query URI '#{uri}': #{response}"
      end
    end 

    def sort_parameter
      @parameters["sort"] = "date:r:#{@from.strftime(FORMAT)}:#{@to.strftime(FORMAT)}"
    end
  end
end
