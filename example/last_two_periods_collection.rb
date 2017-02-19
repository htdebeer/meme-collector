require_relative "../lib/meme_collector/meme_collection"

meme_database = MemeCollector::MemeCollection.load "trump-wall-memes-per-week.db"

last_two_periods = meme_database.periods.where(:id => [83, 84])

last_two_periods.each do |period|
  puts "Collecting new memes for period #{period[:from]} = #{period[:to]}"

  7.times do |i|
    puts "finding more, step #{i}"
    period.find_more
  end
  
  puts 'Getting imgur data for each meme'

  period.memes.each do |meme|
    begin
      meme.get_imgur_data
      puts "Gotten imgur data for meme with id = #{meme[:id]}"
    rescue StandardError => e
      warn e.message
    end
  end
end

