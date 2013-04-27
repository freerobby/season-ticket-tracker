require 'yaml'

class Web < Sinatra::Base
  CONFIG_FILE = "config.yml"
  DB_CONFIG_KEY = "dbopts"

  register Sinatra::Partial

  set :base_directory, File.dirname(__FILE__)
  set :views, File.join(settings.base_directory, "/views")
  set :partial_template_engine, :slim
  set :base_app_title, "Season Ticket Tracker"
  set :config_opts, YAML::load_file(File.join(settings.base_directory, CONFIG_FILE))

  def build_view_options(title, rest={})
    view_options = Hash.new

    view_options.store(:title, "#{settings.base_app_title} | #{title}")

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

  before do
    if @DBconn.nil?
      ping = ping_db_server(settings.config_opts[DB_CONFIG_KEY])

      if (!ping[:can_connect])
        halt 500, slim(:issue, :locals => build_view_options("Error", :info => ping[:conn_err]))
      end

      @DBconn = Sequel.connect(settings.config_opts[DB_CONFIG_KEY])
    end
  end

  get '/' do
    slim :index, :locals => build_view_options("Home")
  end
end