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
require "open-uri"
require "uri"

module RubyGoogleSearch
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
