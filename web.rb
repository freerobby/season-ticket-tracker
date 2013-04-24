class Web < Sinatra::Base
  register Sinatra::Partial

  set :views, "#{File.dirname(__FILE__)}/views"
  set :partial_template_engine, :slim
  set :base_app_title, "Season Ticket Tracker"
  set :db_connection_info, { :host => 'localhost', :port => 5432, :dbname => 'stt'}

  @conn = nil

  def build_view_options(title, rest={})
    view_options = Hash.new

    view_options.store(:title, "#{settings.base_app_title} | #{title}")

    if !rest.nil?
      view_options.merge!(rest)
    end

    view_options
  end

  before do
    conn_err = ""
    can_connect = false

    ping_result = PG::Connection.ping(settings.db_connection_info)

    case ping_result
    when PG::PQPING_OK
      can_connect = true
    when PG::PQPING_REJECT
      conn_err = "Server is alive but rejecting connections"
    when PG::PQPING_NO_RESPONSE
      conn_err = "Could not establish connection"
    when PG::PQPING_NO_ATTEMPT
      conn_err = "Connection not attempted (bad params)"
    end

    if (!can_connect)
      halt 500, slim(:issue, :locals => build_view_options("Error", :info => conn_err))
    end

    if @conn.nil?
      @conn = PG::Connection.new(settings.db_connection_info)
    end
  end

  get '/' do
    slim :index, :locals => build_view_options("Home")
  end
end