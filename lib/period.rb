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

require_relative "./api/search/engine.rb"
require_relative "./meme.rb"

class Period

  # Each period is one week
  SIZE = 7

  attr_reader :type, :from, :to, :count, :last_index, :memes

  def initialize from, to, count = 0, last_index = 1
    @from = from
    @to = to
    @count = count
    @last_index = last_index
    @memes = []
  end

  include Comparable

  def <=>(other)
    return @count <=> other.count
  end

  include Enumerable

  def each(&block)
    @memes.each(&block)
  end

  def add memes
    if memes.is_a?
      memes.each {|meme| add_meme meme}
    else
      add_meme memes
    end

    self
  end

  def update!
    # create a new search engine
    #
    # search
    #
    # add results
    #
    # each new result: update meme info
  end

  def to_h
    {
      :from => @from.to_s,
      :to => @to.to_s,
      :count => @count,
      :last_index => @last_index,
      :memes => @memes.map {|meme| meme.to_h}
    }
  end

  def self.load h
    from = Date.parse h[:from]
    to = Date.parse h[:to]
    count = h[:count]
    expected = h[:last_index]

    period = Period.new from, to, count
    h[:memes].each {|meme_h| period.add Meme.load(meme_h)}
    
    if expected != period.last_index
      raise Error.new "Loaded number of memes (#{period.last_index}) not equal to expected number of memes (#{expected})in #{period.from}-#{period.to}."
    end

    period
  end

  private
  
  def add_meme meme
    @memes.push meme
    @last_index += 1
  end

end
