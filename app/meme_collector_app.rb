require "sinatra/base"
require "erb"
require "sequel"

require_relative "../lib/meme_collector/meme_collection.rb"

MC = MemeCollector::MemeCollection.load "../example/trump-wall-memes-per-week.db"

class MemeCollectorApplication < Sinatra::Base
  set :sessions, true

  helpers do
    def protected!
      return if authorized?
      headers["WWW-Authenticate"] = "Basic realm=\"Restricted Area\""
      halt 401, "Not authorized\n"
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ["admin", "secret"]
    end

    def val(object, field, default = "")
      if object.nil? or object[field].nil? then
        default
      else
        field[field]
      end
    end
  end

  get "/" do
    # by default, open the curated list with future events
    redirect "/overview"
  end

  get "/login" do
    protected!
    redirect "/"
  end

  get "/logout" do
    @auth = nil
    session.clear
    redirect "/"
  end

  get "/overview" do
    @query = MC.query
    @periods = MC.periods
    erb :overview
  end

  get "/histogram" do
      @periods = MC.periods
      @tags = MC.tags
      erb :histogram
  end

  get "/tags" do
    @errors = [] if @errors.nil?
    @tags = MC.tags
    erb :tags
  end

  post "/tags/:action" do |action|
    @errors = []
    if request.form_data? then
      name = request['name']
      if not name.nil? and not name.empty? then
        if action == 'add' then
          if MC.tags[name].nil?
            MC.tags.create {|t| t.name = name }
          else
            @errors.push "Tag with name '#{name}' does already exist: cannot add it."
          end
        elsif action == 'delete' then
          if MC.tags[name].nil?
            @errors.push "Tag with name '#{name}' does not exist: cannot delete it."
          else
            tag = MC.tags[name]
            tag.memes.each do |meme|
              meme.tags_dataset.where(:name => name).delete
            end
            tag.delete
          end
        else
          @errors.push "There is no action '#{action}'; uncertain what to do."
        end
      else
        @errors.push "No tag name given when executing action '#{action}'"
      end

      redirect "/tags"
    else
      halt "No form data?"
    end
  end

  get "/memes/:period/:id" do |period_id, meme_id|
    @errors = [] if @errors.nil?
    @period = MC.periods[period_id]
    @meme = MC.memes[meme_id]
    @tags = MC.tags

    if @meme.nil? then
      halt "Could not find meme with id = #{meme_id}"
    end
    erb :meme, :layout => :no_layout
  end

  get "/valid/memes" do
    @errors = [] if @errors.nil?
    @memes = MC.memes.where(:valid => true).order(:imgur_uploaded)
    erb :valid_memes
  end

  get "/periods/:id" do |period_id|
    @errors = [] if @errors.nil?
    @period = MC.periods[period_id]
    @tags = MC.tags
    if @period.nil? then
      halt "Could not find period with id = #{period_id}"
    end
    erb :period
  end

  post "/memes/update" do
    @errors = []
    if request.form_data? then
      @meme = MC.memes[request['id']]

      if @meme.nil?
        @errors.push "Cannot find meme with id=#{request['id']}"
        halt @errors.join("\n")
      end

      valid = nil
      valid_value = request['valid']
      if not valid_value.nil? and valid_value.size == 1
        valid_value = valid_value[0]
        valid = if valid_value == 'valid' then
                  true
                elsif valid_value == 'invalid' then
                  false
                else
                  @errors.push "Expected the valid parameter to be 'valid' or 'invalid', got '#{valid_value}' instead."
                  nil
                end
      end

      if not valid.nil?
        @meme.update(:valid => valid)
      end
      
      tags = if request['tags'].nil? then [] else request['tags'] end

      new_tags = tags

      @meme.tags_dataset.each do |meme_tag|
        if tags.include? meme_tag.name 
          # keep tag
          new_tags.delete meme_tag.name
        else
          # remove tag
          @meme.remove_tag meme_tag
        end
      end

      new_tags.each do |tag|
        @meme.add_tag MC.tags[tag]
      end

      period_id = request['period']
      redirect "/memes/#{period_id}/#{@meme.id}"
    else
      halt "no form data"
    end
  end
  
  run! if app_file == $0
end
