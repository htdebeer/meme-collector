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
require "uri"
require "net/http"
require "net/https"
require "json"
require "date"

require_relative "./image.rb"
require_relative "./imgur_api_error.rb"

module MemeCollector
  module Api
    module Imgur
      class Engine

        BASE_URL = "https://api.imgur.com"

        def initialize imgur_client_id = ENV["IMGUR_CLIENT_ID"]
          @imgur_client_id = imgur_client_id
        end

        def get_image image_url
          id = image_url.split("/")[-1].split(".")[0]
          in_gallery = image_url.include? "/gallery/"

          end_point = if in_gallery then "gallery/image" else "image" end
          path = "/3/#{end_point}/#{id}.json"

          uri = URI "#{BASE_URL}#{path}"

          headers = {
            "Authorization" => "Client-ID #{@imgur_client_id}"
          }

          request = Net::HTTP::Get.new(path, headers)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          response = http.request(request)
          if response.is_a? Net::HTTPSuccess
            Image.load JSON.parse(response.body)["data"]
          else 
            raise ImgurApiError, "Problem running URI '#{uri}': #{response}"
          end
        end
        
      end
    end
  end
end
