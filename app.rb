# -*- coding: utf-8 -*-
require 'sinatra'
require 'sinatra/asset_pipeline'
require 'active_record'

settings = YAML::load(File.open('config/database.yml'))["development"]

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  host: settings["db_host"],
  database: settings["db_name"],
  username: settings["db_username"],
  password: settings["db_password"]
)


require './masterflatfile.rb'

class App < Sinatra::Base
  register Sinatra::AssetPipeline

  get '/' do
    @site_title = 'Ruby Radiance Dashboard'
    @title = 'Ruby Radiance Dashboard'
    @subtitle = 'created by jrichter'
    haml :index
  end

  get '/test' do
    a = Masterflatfile.first
    columns = []
    a.attributes.each do |c|
      columns << c
    end
    "#{p columns}"
  end
  get '/tests' do
    a = Masterflatfile.all.limit(100)
    records = []
    a.each do |record|
      # [{},{}]
      records << {'accessionNumber' => record.AccessionNumber,
                  'studyDate' => record.StudyDate,
                  'codeMeaning' => record.CodeMeaning,
                  'codeValue' => record.CodeValue,
                  'dose' => record.EstimatedDose}
    end
    records.to_json
  end

  get '/all_scans/:startdate/:enddate/' do
    startdate = params[:startdate]
    puts startdate
    enddate = params[:enddate]
    puts enddate
    records = Masterflatfile.where(:StudyDate => startdate..enddate)
    data = {}
    records = records.group_by(&:CodeValue)
    records.each_pair do |key, record|
      record = record[0]
      a = {key => [record.AccessionNumber, record.EstimatedDose, record.CodeMeaning]}
      data = data.merge(a){|k,old,new| [old] + [new]}
    end
    "#{records.length}, #{data}"
  end
end

# I need charts where:
#   The date range is respected
#   Each tech is compared to each other by exam
#   Listing of the highest doeses in a date range
#   Who scans the hottest and what exams contribute to that
#   ✓ All scans in a date range
#   Patient dose chart for repeat patients in a time period
#   Breakdown of techs to compare phantom size and body part and scan.
#   Chart comaparing BMI to dose

#  the check mark, ✓, press ctrl + v then u 2713 in vim and
#  ctrl + x 8 Enter followed by 2713 for emacs
