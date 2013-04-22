class Web < Sinatra::Base
  register Sinatra::Partial

  set :views, "#{File.dirname(__FILE__)}/views"
  set :partial_template_engine, :slim
  set :base_app_title, "Season Ticket Tracker"

  get '/' do
    slim :index, :locals => {:title => "#{settings.base_app_title} | Home"}
  end
end