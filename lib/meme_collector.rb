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

require "yaml"

require_relative "./wall_collection.rb"

class MemeCollector

  def initialize 
    @meme_collection = nil
  end

  def run!
    @meme_collection.each {|period| period.update!}
    self
  end

  def save path
    full_path = File.expand_path path

    raise Error.new "Unable to write #{path}" unless File.writable? full_path

    begin
      File.open(full_path, "w") do |file|
        file.write YAML.dump(@meme_collection.to_h)
      end
    rescue IOException => e
      raise e
    end
  end

  def self.load path
    full_path = File.expand_path path

    raise Error.new "Unable to find #{path}" unless File.exist? full_path
    raise Error.new "Unable to read #{path}" unless File.readable? full_path
      
    begin
      @meme_collection = WallCollection.load YAML.load(File.read(path))
    rescue IOException => e
      raise e
    end
  end
end
