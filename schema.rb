require 'rubygems'
require 'pg'
require 'sequel'
require 'yaml'

configopts = YAML::load_file(File.join(File.dirname(__FILE__), "config.yml"))

Sequel.connect(configopts["dbopts"]) do |db|

  # create teams table
  if !db.table_exists?(:teams)
    puts "Creating - Teams table"

    db.create_table(:teams) do
      primary_key :id
      String :name
      String :stadium
      String :city
      String :state
      DateTime :last_updated
      DateTime :created
      Boolean :active
    end

    puts "Created - Teams table"
  else
    puts "Already Created - Teams table"
  end


  # create games table
  if !db.table_exists?(:games)
    puts "Creating - Games table"

    db.create_table(:games) do
      primary_key :id
      foreign_key :team_id, :teams
      String :opponent
      String :stadium
      String :description
      DateTime :date_time
      DateTime :last_updated
      DateTime :created
      Boolean :active
    end

    puts "Created - Games table"
  else
    puts "Already Created - Games table"
  end

  # create seasons table
  if !db.table_exists?(:seasons)
    puts "Creating - Seasons table"

    db.create_table(:seasons) do
      primary_key :id
      foreign_key :team_id, :teams
      Integer :year
      DateTime :last_updated
      DateTime :created
      Boolean :active
    end

    puts "Created - Seasons table"
  else
    puts "Already Created - Seasons table"
  end

  # create seasongames table
  if !db.table_exists?(:seasongames)
    puts "Creating - Season Games table"

    db.create_table(:seasongames) do
      foreign_key :season_id, :seasons
      foreign_key :game_id, :games
    end

    puts "Created - Season Games table"
  else
    puts "Already Created - Season Games table"
  end

end