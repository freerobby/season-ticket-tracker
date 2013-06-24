require 'rubygems'
require 'pg'
require 'yaml'
require 'dm-migrations'
require 'data_mapper'

DataMapper.setup(:default, 'postgres://localhost:5432/stt')

Dir[File.dirname(__FILE__) + '/models/*.rb'].each { |file| require file }

DataMapper.finalize
DataMapper.auto_migrate!