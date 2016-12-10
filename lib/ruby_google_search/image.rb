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
require_relative "./item.rb"

module RubyGoogleSearch

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
