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

#configopts = YAML::load_file(File.join(File.dirname(__FILE__), "config.yml"))

DataMapper.setup(:default, 'postgres://localhost:5432/stt')

Dir[File.dirname(__FILE__) + '/models/*.rb'].each { |file| require file }

DataMapper.finalize
DataMapper.auto_migrate!

#DataMapper::Model.raise_on_save_failure = true

# need to require after setting up db connection
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }

cubs_sched = MLBSchedules::Schedule.new(112, 2013, true, true)
csv = cubs_sched.request_csv
games = cubs_sched.parse_csv(csv)

team = Team.create(:name => "CC", :stadium => "C", :city => "city", :state => "state", :created_at => Time.new)

puts "Created Team ID: #{team.id}"

season = Season.create(:team_id => team.id, :year => 2013, :created_at => Time.now)

puts "Created Season ID: #{season.id}"

games.each do |game|
  newgame = Game.create(:opponent => game.opponent, :location => game.location, :description => game.description, :gametime => game.datetime)

  SeasonGame.create(:game => newgame, :season => season)
end

puts "Created #{games.count} Games"

