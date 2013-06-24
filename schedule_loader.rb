begin
  gem "mlbschedules"
rescue Gem::LoadError
  puts "mlbschedules gem is not installed"
  exit
end

require 'rubygems'
require 'pg'
require 'yaml'
require 'mlbschedules'
require 'dm-migrations'
require 'data_mapper'

# get the db config options
CONFIG_FILE = "config.yml"
DB_CONFIG_KEY = "dbopts"
configopts = YAML::load_file(File.join(File.dirname(__FILE__), CONFIG_FILE))

# create datamapper instance
DataMapper.setup(:default, configopts[DB_CONFIG_KEY])

# include all of the modesl
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file}

# check that the models are correct before inserting
DataMapper.finalize

# migrate any changes to the tables (schema can handle later)
DataMapper.auto_migrate!

# to handle global model save errors
#DataMapper::Model.raise_on_save_failure = true

# get the schedule information using mlbschedules gem
cubs_sched = MLBSchedules::Schedule.new(112, 2013, true, true)
csv = cubs_sched.request_csv
games = cubs_sched.parse_csv(csv)

# create team
team = Team.create(:name => "Chicago Cubs", :stadium => "Wrigley Field", :city => "Chicago", :state => "Illinois", :created_at => Time.new)

puts "Created Team ID: #{team.id}"

season = Season.create(:team_id => team.id, :year => 2013, :created_at => Time.now)

puts "Created Season ID: #{season.id}"

games.each do |game|
  newgame = Game.create(:opponent => game.opponent, :location => game.location, :description => game.description, :gametime => game.datetime)

  SeasonGame.create(:game => newgame, :season => season)
end

puts "Created #{games.count} Games"

