require 'rubygems'
require 'pg'
require 'sequel'
require 'yaml'

configopts = YAML::load_file(File.join(File.dirname(__FILE__), "config.yml"))

Sequel.connect(configopts["dbopts"]) do |db|
  # create games table
  if !db.table_exists?(:games)
    puts "Creating - Games table"

    db.create_table(:games) do
      primary_key :id
      String :opponent
      String :stadium
      String :description
      DateTime :date_time
      DateTime :last_updated
      Boolean :active
    end

    puts "Created - Games table"
  else
    puts "Already Created - Games table"
  end
end