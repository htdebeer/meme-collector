# Copyright 2016, Huub de Beer <Huub@heerdebeer.org>
#
# This file is part of wall-meme-collector.
#
# wall-meme-collector is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by the
# Free Software Foundation, either version 3 of the License, or (at your
# option) any later version.
#
# wall-meme-collector is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# wall-meme-collector.  If not, see <http://www.gnu.org/licenses/>.
require_relative "./item.rb"

module Api
  module Search

    class Image < Item

      attr_reader :context, :height, :width, :thumbnail 

      def initialize item
        super item
        image = item["image"]
        @context = image["contextLink"]
        @height = image["height"]
        @width = image["width"]
        @thumbnail = image["thumbnailLink"]
      end

      def to_h
        h = super
        h["context"] = @context
        h["height"] = @height
        h["width"] = @width
        h["thumbnail"] = @thumbnail
        h
      end

    end
  end
end
