class Web < Sinatra::Base
  register Sinatra::Partial

  set :views, "#{File.dirname(__FILE__)}/views"
  set :partial_template_engine, :slim
  set :base_app_title, "Season Ticket Tracker"
  set :db_connection_info, { :host => 'localhost', :port => 5432, :dbname => 'stt'}

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
      halt 500, slim(:issue, :locals => {:title => "#{settings.base_app_title} | Error", :info => conn_err})
    end

    @conn = PG::Connection.new(settings.db_connection_info)
  end

  get '/' do
    slim :index, :locals => {:title => "#{settings.base_app_title} | Home"}
  end
end