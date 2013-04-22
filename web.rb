class Web < Sinatra::Base
  set :views, "#{File.dirname(__FILE__)}/views"

  set :base_app_title, "Season Ticket Tracker"

  get '/' do
    slim :index, :locals => {:title => "#{settings.base_app_title} | Home"}
  end
end