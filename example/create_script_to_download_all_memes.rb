require_relative "../lib/meme_collector/meme_collection"

puts "#/usr/bin/bash"
meme_database = MemeCollector::MemeCollection.load "trump-wall-memes-per-week.db"
meme_database.memes.each do |meme|
    ext = if meme.imgur_type.nil? then "jpg" else meme.imgur_type.split("/").last end
    file = "#{meme.id}.#{ext}"
    puts "if ! [ -f #{file} ]; then curl #{meme.link} -o #{meme.id}.#{ext}; fi"
end
