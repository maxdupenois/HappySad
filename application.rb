require 'rubygems'
require 'bundler/setup'

Bundler.require


require File.join(File.dirname(__FILE__), *%w[lib/page_scraper])
require File.join(File.dirname(__FILE__), *%w[lib/sentiment_scorer])

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
  ps = PageScraper.new(website)
  @err = nil
  page = begin
    ps.scrape 
  rescue StandardError => err 
    nil
  end
  @err = err
  sentiment_scorer = SentimentScorer.new(page)
  @score, @word_to_score = sentiment_scorer.score
  haml :index
end