class Web < Sinatra::Base
  register Sinatra::Partial

  set :views, "#{File.dirname(__FILE__)}/views"
  set :partial_template_engine, :slim
  set :base_app_title, "Season Ticket Tracker"
  set :db_connection_info, { :host => 'localhost', :port => 5432, :dbname => 'stt'}

  def build_view_options(title, rest={})
    view_options = Hash.new

    view_options.store(:title, "#{settings.base_app_title} | #{title}")

    if !rest.nil?
      view_options.merge!(rest)
    end

    view_options
  end

  def ping_db_server(connection_options)
    value = { :conn_err => "", :can_connect => false }

    ping_result = PG::Connection.ping(connection_options)

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
      ping = ping_db_server(settings.db_connection_info)

      if (!ping[:can_connect])
        halt 500, slim(:issue, :locals => build_view_options("Error", :info => ping[:conn_err]))
      end

      conn_opts = { :host => settings.db_connection_info[:host],
                    :database => settings.db_connection_info[:dbname] }

      @DBconn = Sequel.postgres(conn_opts)
    end
  end

  get '/' do
    slim :index, :locals => build_view_options("Home")
  end
end