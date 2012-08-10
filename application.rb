require 'rubygems'
require 'bundler/setup'

Bundler.require


require File.join(File.dirname(__FILE__), *%w[lib/page_scraper])

configure do
  set :views, "#{File.join(File.dirname(__FILE__), *%w[views])}"
  set :public_folder, "#{File.join(File.dirname(__FILE__), *%w[assets])}"
  set :public, "#{File.join(File.dirname(__FILE__), *%w[assets])}"
end

get "/" do
  haml :index
end

post "/" do 
  website = params['website']
  website = "http://#{website}" if(not website =~ /^http.*/)
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