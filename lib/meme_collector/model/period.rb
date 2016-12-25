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
require "sequel"

require_relative "../meme_collector_error.rb"
require_relative "../api/search/search_api_error.rb"
require_relative "../api/search/engine.rb"
require_relative "./meme"

module MemeCollector
  class Period < Sequel::Model
    many_to_many :memes, :join_table => :rankings

    def find_more
      engine = Api::Search::Engine.new
      engine.from from
      engine.to to
      engine.start start_index
      engine.query query
      engine.find_only_images
      engine.site "imgur.com"

      begin
        results = engine.search

        update(:count => results.total_results) if count < 0

        results.each do |result|
          meme = Meme.where(:link => result.link).first
          
          if meme.nil?
            meme = Meme.create(:link => result.link, :context => result.context)
          end

          meme.get_imgur_data

          add_meme(meme)

          Ranking
            .where(:meme_id => meme.id, :period_id => id, :rank => -1)
            .first
            .update(:rank => result.rank)
        end
      rescue Api::Search::SearchApiError, Api::Imgur::ImgurApiError => e
        warn "Error while trying to collect more memes: #{e.message}"
      end
    end

    private

    def query
      db[:about].first[:query]
    end

    def start_index
      Ranking.where(:period_id => id).count + 1
    end
  end
end
