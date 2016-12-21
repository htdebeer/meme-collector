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

require "date"

require_relative "./period.rb"
require_relative "./meme.rb"

class MemeCollection

  attr_reader :from, :to, :period_type

  def initialize from, to, periods = []
    raise Error.new "To-date #{to} should be later than from-date #{from}." if from > to

    @from = from
    @to = to

    if periods.empty?
      initialize_periods!
    else
      @periods = periods
    end
  end
  
  include Enumerable

  def each(&block)
    @periods.each(&block)
  end

  def to_h
    {
      :from => @from.to_s,
      :to => @to.to_s,
      :periods => @periods.map {|period| period.to_h}
    }
  end

  def self.load h
    from = Date.parse h[:from]
    to = Date.parse h[:to]
    periods = h[:periods].map { |period_h| Period.load period_h }
    MemeCollection.new from, to, periods
  end

  private

  def initialize_periods!
    @periods = []
    start = @from

    while start < @to
      till = start + Period.SIZE
      @periods.push Period.new(start, till)
      start = till
    end

    @to = start if start > @to
  end
end

