require 'rubygems'
require 'bundler/setup'
# require 'dl/import'
# DL::Importable = DL::Importer
Bundler.require

# require 'mongo'
# 
# Mongoid.configure do |config|
#   config.master = Mongo::Connection.new.db("")
# end

require File.join(File.dirname(__FILE__), *%w[lib/page_scraper])

configure do
  set :views, File.join(File.dirname(__FILE__), *%w[views])
end

get "/" do
  haml :index
end

post "/" do 
  website = params['website']
  ps = PageScraper.new(website)
  @err = nil
  contents = begin
    ps.scrape 
  rescue StandardError => err 
    nil
  end
  @err = err
  @score = ps.score(contents)
  haml :index
end