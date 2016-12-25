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
require_relative "../api/imgur/imgur_api_error.rb"
require_relative "../api/imgur/engine.rb"

module MemeCollector
  class Meme < Sequel::Model
    many_to_many :periods, :join_table => :rankings
    many_to_many :tags, :left_key => :meme_id, :right_key => :tag_name, :join_table => :tagged

    def validated?
      not valid.nil?
    end

    def get_imgur_data
      begin
        engine = Api::Imgur::Engine.new
        image = engine.get_image link
        update(
          :imgur_id => image.id,
          :imgur_title => image.title,
          :imgur_description => image.description,
          :imgur_uploaded => image.uploaded,
          :imgur_type => image.type,
          :imgur_width => image.width,
          :imgur_height => image.height,
          :imgur_size => image.size,
          :imgur_views => image.views,
          :imgur_bandwidth => image.bandwidth,
          :imgur_section => image.section
        )
      rescue Api::Imgur::ImgurApiError => e
        warn MemeCollectorError.new "Error while trying to find more memes: #{e.message}"
      end
    end

  end
end
