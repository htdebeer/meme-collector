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

require_relative "./meme_collector_error.rb"

module MemeCollector
  class MemeCollection
    
    PERIOD_SIZE = 7

    def initialize path, configuration = {}
      db = Sequel.sqlite path

      if db.table_exists?(:about)
        raise MemeCollectorError.new "Database already exists" if !configuration.empty?
        @about = db[:about].first
      else
        query = configuration[:query]
        raise MemeCollectorError.new "No query specified" if query.nil? or query.empty?

        # Meme collector collects memes, so ensure the search string contains
        # the substring "meme"
        if not query.include? "meme"
          query = "meme " + query
        end

        from = configuration[:from]
        raise MemeCollectorError.new "No from-date specified" if from.nil?

        to = configuration[:to]
        raise MemeCollectorError.new "No to-date specified" if to.nil?

        raise MemeCollectorError.new "To-date #{to} should be later than from-date #{from}." if from > to

        db = create_database db, query, from, to
      end
      
      # Load models
      Sequel::Model.db = db
      require_relative "model/period.rb"
      require_relative "model/meme.rb"
      require_relative "model/tag.rb"
      require_relative "model/ranking.rb"
    end

    def self.generate path, configuration
      MemeCollection.new path, configuration
    end

    def self.load path
      MemeCollection.new path, {}
    end

    def memes
      MemeCollector::Meme
    end

    def periods
      MemeCollector::Period
    end

    def tags
      MemeCollector::Tag
    end

    def rankings
      MemeCollector::Ranking
    end

    def about
      @about
    end

    def query
      about[:query]
    end

    def created
      about[:created]
    end

    def from
      periods.first[:from]
    end

    def to
      periods.where(:id => periods.max(:id)).first[:to]
    end

    # Collects 10 more memes per period
    #
    # raises error
    def collect!
      periods.each do |period|
        begin
          period.find_more
        rescue MemeCollectorError => e
          warn e.message
        end
      end
      self
    end

    private

    def create_database db, query, from, to
      db.create_table(:about) do
        String :query
        DateTime :created
      end

      about = db[:about]
      about.insert(:query => query, :created => DateTime.now.to_s)

      db.create_table(:periods) do
        primary_key :id
        Date :from
        Date :to
        Bignum :count, :default => -1
      end

      periods = db[:periods]
      start = from
      while start < to
        till = start + PERIOD_SIZE
        periods.insert :from => start, :to => till
        start = till + 1
      end

      db.create_table(:memes) do
        # general properties
        primary_key :id
        TrueClass :valid, :null => true

        # Google Custom Search API properties
        String :link
        String :context

        # Imgur properties
        String :imgur_id, :null => true
        String :imgur_title, :null => true
        String :imgur_description, :null => true
        DateTime :imgur_uploaded, :null => true
        String :imgur_type, :null => true
        Fixnum :imgur_width, :null => true # in pixels
        Fixnum :imgur_height, :null => true # in pixels
        Fixnum :imgur_size, :null => true # in bytes
        Fixnum :imgur_views, :null => true
        Fixnum :imgur_bandwidth, :null => true
        String :imgur_section, :null => true
      end

      db.create_table(:rankings) do
        primary_key :id
        Fixnum :meme_id
        Fixnum :period_id
        Fixnum :rank, :default => -1
      end

      db.create_table(:tags) do
        String :name, :primary_key => true
        String :description, :text => true, :null => true
      end

      db.create_table(:tagged) do
        Fixnum :meme_id
        String :tag_name
        primary_key [:meme_id, :tag_name]
      end
    end

  end
end
