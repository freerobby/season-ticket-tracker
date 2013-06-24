require 'yaml'
require 'json'

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
    #DB = Sequel.connect(settings.config_opts[DB_CONFIG_KEY])

    DataMapper.setup(:default, 'postgres://localhost:5432/stt')
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

  get '/seasons/:team_id/?' do
    content_type 'application/json'

    #Season.active_seasons(params[:team_id]).to_json
  end

  get '/games/?' do
    content_type 'application/json'

    #results = Game.active_games

    #results.to_json
  end

  get '/games/all/?' do
    content_type 'application/json'

    #Game.all.to_json
  end

  post '/game/:id/set/:active' do
    active = params[:active].downcase.eql?("active")

    #Game.set_game_active_status(params[:id], active)

    status 200
  end

  #Sequel::Model.plugin :json_serializer

  # require model classes
  Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
end