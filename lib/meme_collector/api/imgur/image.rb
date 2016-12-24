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
require "date"

module MemeCollector
  module Api
    module Imgur

      class Image

        attr_reader :id, :title, :description, :uploaded, :type, :width, :height, :size, :views, :bandwidth, :section

        def initialize id, title, description, uploaded, type, width, height, size, views, bandwidth, section
          @id = id
          @title = title
          @description = description
          @uploaded = uploaded
          @type = type
          @width = width
          @height = height
          @size = size
          @views = views
          @bandwidth = bandwidth
          @section = section
        end

        def self.load h
          id = h["id"]
          title = h["title"]
          description = h["description"]
          uploaded = Time.at(h["datetime"]).to_datetime
          type = h["type"]
          width = h["width"]
          height = h["height"]
          size = h["size"]
          views = h["views"]
          bandwidth = h["bandwidth"]
          section = h["section"]
  
          Image.new id, title, description, uploaded, type, width, height, size, views, bandwidth, section
        end

      end
    end
  end
end
