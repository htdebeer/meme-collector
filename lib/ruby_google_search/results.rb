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
require "json"
require "yaml"

require_relative "./engine.rb"
require_relative "./item.rb"
require_relative "./image.rb"

module RubyGoogleSearch
  class Results

    include Enumerable

    attr_reader :engine, :total_results, :start_index, :count

    def initialize engine, total_results, start_index, count, items
      @engine = engine
      @total_results = total_results
      @start_index = start_index
      @count = count
      @items = items
    end

    def each(&block)
      @items.each(&block)
    end

    def merge! other
      other.each do |item|
        @items << item
      end
      @count += other.count
      self
    end

    def self.from_json engine, json_data
      data = JSON.parse json_data
      queries = data["queries"]
      request = queries["request"][0]

      total_results = Integer(request["totalResults"])
      start_index = Integer(request["startIndex"])
      count = Integer(request["count"])

      items = []
      if data.has_key? "items" 
        data["items"].each do |item|
          if item.has_key? "image"
            items.push RubyGoogleSearch::Image.new(item)
          else
            items.push RubyGoogleSearch::Item.new(item)
          end
        end
      end

      Results.new engine,
        total_results,
        start_index,
        count,
        items
    end

    def self.from_yaml yaml_data
      load YAML.load(yaml_data)
    end

    def self.load data
      total_results = data["total_results"]
      start_index = data["start_index"]
      count = data["count"]
      items = []
      data["items"].each do |item|
        if item.has_key? "thumbnail"
          items.push RubyGoogleSearch::Image.new(item)
        else
          items.push RubyGoogleSearch::Item.new(item)
        end
      end

      engine = RubyGoogleSearch::Engine.load data["engine"]

      Results.new engine,
        total_results,
        start_index,
        count,
        items
    end

    def to_h
      {
        "engine" => @engine.to_h,
        "total_results" => @total_results,
        "start_index" => @start_index,
        "count" => @count,
        "items" => @items.map {|item| item.to_h}
      }
    end

    def to_json
      JSON.generate(to_h)
    end

    def to_yaml
      YAML.dump(to_h)
    end
  end
end
