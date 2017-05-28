# Meme-collector

Collect memes from Imgur about a topic during a period.

This program is still under heavy development.

## Licence

meme-collector is released under the GPLv3

## Requirements

To run the meme-collector

- sinatra for the web application
- sequel for access to the database
- sqlite3 for access to the database

To collect memes:

- Google API key and Google Custom Search Engine ID to find memes
- Imgur API key to get meme image information from Imgur

## Installation

    git clone https://github.com/htdebeer/meme-collector.git

    sudo gem install sinatra
    sudo gem install sqlite3
    sudo gem install sequel

## Usage

### Example scripts to collect Trump/wall memes

In the example directory you'll find three scripts and a database that collect
memes about Trump and walls:

1. `create_trump_wall_meme_collector.rb` to create the `trump-wall-memes.db`
   database. If it already exists, it'll exit with an error. Adapt the script
   to create a different meme collector and / database file.

2. `collect_trump_wall_memes.rb` to collect more memes through the Google Custom
   Search API. Note the 100 requests a day limit for this API when you're
   using it for free. You need a Google API key and a Google Custom Search
   Engine id. 

3. `get_imgur_data_trump_wall_memes.rb` to use the Imgur API to gather more
   information on the collected memes. You need a Imgur API key.

Run these example scripts as follows, for example:   
    
    cd /path/to/meme-collector
    ruby example/collect_trump_wall_memes.rb

### Web application to validate and tag memes

In the app directory you'll find the `meme_collector_app.rb` script, which is a
Sinatra based web application. It now points to the `trump-wall-memes.db` file
in the example directory, but you can point it to any meme database you want.

You can run the web application on your local machine as follows:

    cd /path/to/meme-collector
    cd app
    ruby meme_collector_app.rb

Now open [http://localhost:4567](http://localhost:4567) to explore, tag, and
validate the collected memes. There is also a histogram page to allow a
very simple visual exploration of the collected and tagged memes.

### Sqlite3

The collected memes are stored in a Sqlite3 database, which is just one file.
In the example directory you'll find `trump-wall-memes.db`. You can open it with
the Sqlite3 command-line program as follows:

    cd /path/to/meme-collector
    sqlite3 example/trump-wall-memes.db

The Sqlite3 shell opens. See its documentation on how to use it. Some example
queries:

- Select the number of memes collected:

      SELECT COUNT(*) FROM memes;

- Select the number of ranked memes:

      SELECT COUNT(*) FROM rankings;

- List the tags and the number of tagged memes, sorted from most tagged to
  least tagged:

      SELECT COUNT(meme_id) AS count, tag_name 
      FROM tagged 
      GROUP BY tag_name
      ORDER BY count DESC;

- List the tags and the number of tagged memes, sorted from most tagged to
  least tagged, but only show the 10 most tagged tags:

      SELECT COUNT(meme_id) AS count, tag_name 
      FROM tagged 
      GROUP BY tag_name
      ORDER BY count DESC
      LIMIT 10;

  Currently, this gives as result:

      1954| Donald Trump
      1329| presidential candidate 2016
      775 | wall
      348 | Mexico
      273 | Make _ Great Again
      181 | Hillary Clinton
      115 | the media
      102 | China
      99  | twitter
      86  | hair

- List those tags that have been tagged less than 6 times:

      SELECT COUNT(meme_id) AS count, tag_name 
      FROM tagged 
      GROUP BY tag_name
      HAVING count <= 5 
      ORDER BY count;

  Apparently, there are only 12:

      1|anti-Trump
      1|mechco
      1|oil
      1|rigged
      2|Marie Le Pen
      3|Boris Johnson
      3|golf
      3|lock her up
      4|fascist
      5|Brexit
      5|black lives matter
      5|not my president

### Download all memes

The script `example/create_script_to_download_all_memes.rb` writes to STDOUT a
script with for each meme the following line:

    if ! [ -f <id>.jpeg ]; then curl http://i.imgur.com/<link> -o <id>.jpeg; fi

In other words, it downloads each meme to a file named by the meme's id in the
database and its extension. If the file already exists, it does not download
again. 

The output of the scripts is put in `app/public/img/download_images.sh`. If
you run this file in that directory, it will download the images to the
directory `app/public/img`.

These images are used by the simple histogram representation, which puts all
the images per week and you can show/hide a meme by its tags. These images are
not added to the repository.

Warning: there are for about 1.8 GB meme images in the database. Also, when
loading the histogram, it will load all these images as well.
