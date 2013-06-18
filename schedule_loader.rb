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
  Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }

  cubs_sched = MLBSchedules::Schedule.new(112, 2013, true, true)
  csv = cubs_sched.request_csv
  games = cubs_sched.parse_csv(csv)

  # clear existing games; won't always be used
  Game.clear

  team_id = Team.insert_new("Chicago Cubs", "Wrigley Field", "Chicago", "IL")

  puts "Created Team: #{team_id}"

  season_id = Season.insert_new(team_id, 2013)

  puts "Created Season: #{season_id}"

  games.each do |game|
    Game.insert_new(team_id, game.opponent, game.location, game.description, game.datetime)
  end

  puts "Created #{games.count} Games"

end