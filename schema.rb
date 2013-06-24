require 'rubygems'
require 'pg'
require 'yaml'
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