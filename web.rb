class Web < Sinatra::Base
  register Sinatra::Partial

  set :views, "#{File.dirname(__FILE__)}/views"
  set :partial_template_engine, :slim
  set :base_app_title, "Season Ticket Tracker"

  before do
    ping_result = PG::Connection.ping('localhost', 5432, nil, nil, 'stt', nil, nil)
    is_connectable = ping_result == PG::PQPING_OK ? true : false

    if (!is_connectable)
      raise "Cannot connect to database"
    end

    @conn = PG::Connection.new('localhost', 5432, nil, nil, 'stt', nil, nil)
  end

  get '/' do
    slim :index, :locals => {:title => "#{settings.base_app_title} | Home"}
  end
end