require 'yaml'
require 'json'
require 'dm-serializer'

class Web < Sinatra::Base
  CONFIG_FILE = "config.yml"
  DB_CONFIG_KEY = "dbopts"

  register Sinatra::Partial

  set :base_directory, File.dirname(__FILE__)
  set :views, File.join(settings.base_directory, "/views")
  set :partial_template_engine, :slim
  set :base_app_title, "Season Ticket Tracker"
  set :config_opts, YAML::load_file(File.join(settings.base_directory, CONFIG_FILE))

  def build_view_options(title, admin=false, rest={})
    view_options = Hash.new

    view_options.store(:title, "#{settings.base_app_title} | #{title}")

    view_options.store(:admin, admin)

    if !rest.nil?
      view_options.merge!(rest)
    end

    view_options
  end

  def ping_db_server(conn_opts)
    value = { :conn_err => "", :can_connect => false }

    # transform hash to use expected params by PG gem
    params = { :host => conn_opts[:host], :dbname => conn_opts[:database] }

    ping_result = PG::Connection.ping(params)

    case ping_result
    when PG::PQPING_OK
      value[:can_connect] = true
    when PG::PQPING_REJECT
      value[:conn_err] = "Server is alive but rejecting connections"
    when PG::PQPING_NO_RESPONSE
      value[:conn_err] = "Could not establish connection"
    when PG::PQPING_NO_ATTEMPT
      value[:conn_err] = "Connection not attempted (bad params)"
    end

    value
  end

  configure do
    #DataMapper::Logger.new(STDOUT, :debug)
    DataMapper.setup(:default, settings.config_opts[DB_CONFIG_KEY])
  end

  get '/' do
    slim :index, :locals => build_view_options("Home")
  end

  get '/about/?' do
    slim :about, :locals => build_view_options("About")
  end

  get '/admin/?' do
    slim :admin, :locals => build_view_options("Administration", true)
  end

  # api methods

  get '/game/:id/?' do
    #SeasonGame.all(:active => true, :game => { :id => params[:id]}).to_json
  end

  get '/games/:year/?' do
    content_type 'application/json'

    year = params[:year]

    season_data = SeasonGame.all(:active => true, :season => { :year => year }).games

    season_data.to_json
  end

  get '/games/:year/all/?' do
    content_type 'application/json'

    year = params[:year]

    games_data = SeasonGame.all(:season => { :year => year })

    return_data = Array.new

    games_data.each do |season_game|
      game_data = Hash.new

      game_data[:used] = season_game.used
      game_data[:sold] = season_game.sold
      game_data[:active] = season_game.active
      game_data[:id] = season_game.game.id
      game_data[:opponent] = season_game.game.opponent
      game_data[:location] = season_game.game.location
      game_data[:description] = season_game.game.description
      game_data[:gametime] = season_game.game.gametime
      game_data[:created_at] = season_game.game.created_at

      return_data.push(game_data)
    end

    return_data.to_json
  end

  post '/game/:id/set/:active' do
    active = params[:active].downcase.eql?("active")

    game = SeasonGame.first(:game => {:id => params[:id]})
    game.active = active
    saved = game.save

    if saved
      status 200
    else
      status 424
    end
  end

  post '/game/:id/set/sold/:status' do
    sold = params[:status].downcase.eql?("sold")

    game = SeasonGame.first(:game => {:id => params[:id]})
    game.sold = sold
    saved = game.save

    if saved
      status 200
    else
      status 424
    end
  end

  post '/game/:id/set/used/:status' do
    used = params[:status].downcase.eql?("used")

    game = SeasonGame.first(:game => {:id => params[:id]})
    game.used = used
    saved = game.save

    if saved
      status 200
    else
      status 424
    end
  end

  # require model classes
  Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
end