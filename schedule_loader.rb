begin
  gem "mlbschedules"
rescue Gem::LoadError
  puts "mlbschedules gem is not installed"
  exit
end

require 'rubygems'
require 'pg'
require 'sequel'
require 'yaml'
require 'mlbschedules'

configopts = YAML::load_file(File.join(File.dirname(__FILE__), "config.yml"))

Sequel.connect(configopts["dbopts"]) do |db|

  # need to require after setting up db connection
  require './models/game'

  cubs_sched = MLBSchedules::Schedule.new(112, 2013, true, true)
  csv = cubs_sched.request_csv
  games = cubs_sched.parse_csv(csv)

  # clear existing games; won't always be used
  Game.clear

  games.each do |game|
    Game.insert_new(game.opponent, game.location, game.description, game.datetime)
  end

end