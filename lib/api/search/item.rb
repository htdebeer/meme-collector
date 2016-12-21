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
require "open-uri"
require "uri"

module Api
  module Search
    class Item
      attr_reader :title, :link

      def initialize item
        @title = item["title"]
        @link = item["link"]
      end

      def download dir = "."
        downloaded = open(@link)
        path = File.join(dir, File.basename(URI(@link).path))
        IO.copy_stream(downloaded, path)
      end


      def to_h
        {
          "title" => @title,
          "link" => @link
        }
      end
    end
  end
end
