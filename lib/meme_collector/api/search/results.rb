# Copyright 2016, Huub de Beer <Huub@heerdebeer.org>
#
# This file is part of meme-collector.
#
# meme-collector is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by the
# Free Software Foundation, either version 3 of the License, or (at your
# option) any later version.
#
# meme-collector is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# meme-collector.  If not, see <http://www.gnu.org/licenses/>.
require "json"
require "yaml"

require_relative "./engine.rb"
require_relative "./item.rb"
require_relative "./image.rb"

module MemeCollector
  module Api
    module Search
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

        def self.from_json engine, json_data
          data = JSON.parse json_data
          queries = data["queries"]
          request = queries["request"][0]

          total_results = Integer(request["totalResults"])
          start_index = Integer(request["startIndex"])
          count = Integer(request["count"])

          items = []
          if data.has_key? "items" 
            rank = start_index
            data["items"].each do |item|
              if item.has_key? "image"
                items.push Image.new(item, rank)
              else
                items.push Item.new(item, rank)
              end
              rank += 1
            end
          end

          Results.new engine,
            total_results,
            start_index,
            count,
            items
        end
      end
    end
  end
end
