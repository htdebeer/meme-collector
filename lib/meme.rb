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

require "uri"

class Meme

  attr_reader :url, :context, :tags

  def initialize url, context, valid = :not_validated
    @url = url
    @context = context
    @valid = valid
    @tags = Set.new
  end

  def update!
    # find information on Imgur
  end

  def tag! key
    @tags.add key
  end

  def untag! key
    @tags.delete? key
  end

  def has_tag? key
    @tags.member? key
  end

  def validated?
    @valid != :not_validated
  end

  def validate!
    @valid = :valid
  end

  def invalidate!
    @valid = :invalid
  end

  def valid?
    @valid == :valid
  end

  def not_valid?
    @valid == :invalid
  end

  def id
    # convert url to Imgur id
  end

  def to_h
    {
      :url => @url.to_s,
      :context => @context.to_s,
      :valid => @valid.to_s
    }
  end

  def self.load h
    url = URI h[:url]
    context = URI h[:context]
    valid = h[:valid].to_sym

    meme = Meme.new url, context, valid
    meme
  end
end
