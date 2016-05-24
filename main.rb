require 'json'
require 'active_record'
require 'yaml'
require 'standalone_migrations'
require './app/models/message'
require './config'

ActiveRecord::Base.establish_connection(
  YAML.load(File.read('./db/config.yml'))[
    ENV['RAILS_ENV'] || 'development'
  ]
)
