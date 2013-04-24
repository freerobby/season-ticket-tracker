class Web < Sinatra::Base
  register Sinatra::Partial

  set :views, "#{File.dirname(__FILE__)}/views"
  set :partial_template_engine, :slim
  set :base_app_title, "Season Ticket Tracker"
  set :db_connection_info, { :host => 'localhost', :port => 5432, :dbname => 'stt'}

  before do
    ping_result = PG::Connection.ping(settings.db_connection_info)
    is_connectable = ping_result == PG::PQPING_OK ? true : false

    if (!is_connectable)
      halt 500, slim(:issue, :locals => {:title => "#{settings.base_app_title} | Error"})
    end

    @conn = PG::Connection.new(settings.db_connection_info)
  end

  get '/' do
    slim :index, :locals => {:title => "#{settings.base_app_title} | Home"}
  end
end