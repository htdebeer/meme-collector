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
require "open-uri"
require "uri"

module MemeCollector
  module Api
    module Search
      class Item
        attr_reader :title, :link, :rank

        def initialize item, rank
          @title = item["title"]
          @link = item["link"]
          @rank = rank
        end
      end
    end
  end
end
