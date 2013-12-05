require 'sinatra'
require 'active_record'
require './masterflatfile.rb'

settings = YAML::load(File.open('config/database.yml'))["development"]

ActiveRecord::Base.establish_connection(
  adapter: "mysql2", 
  host: settings["db_host"],
  database: settings["db_name"],
  username: settings["db_username"],
  password: settings["db_password"]
)

get '/' do
  a = Masterflatfile.first
  columns = []
  a.attributes.each do |c|
    columns << c
  end
  "#{p columns}"
end
