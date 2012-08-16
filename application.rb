require 'rubygems'
require 'bundler/setup'

Bundler.require


require File.join(File.dirname(__FILE__), *%w[lib/page_scraper])
require File.join(File.dirname(__FILE__), *%w[lib/sentiment_scorer])

configure do
  enable :sessions
  set :views, "#{File.join(File.dirname(__FILE__), *%w[views])}"
  set :public_folder, "#{File.join(File.dirname(__FILE__), *%w[assets])}"
  set :public, "#{File.join(File.dirname(__FILE__), *%w[assets])}"
end

before do
  session[:imgtype] = "nick" if(!session.key?(:imgtype))
  @imgtype = session[:imgtype]
end

get "/swtchimg" do
  session[:imgtype] = (@imgtype=="fwd" ? "nick" : "fwd")
  redirect '/'
end


get "/" do
  haml :index
end

def process_webpage(page_url)
  ps = PageScraper.new(page_url)
  err = nil
  page = begin
    ps.scrape 
  rescue StandardError => err 
    nil
  end
  err = err
  sentiment_scorer = SentimentScorer.new(page)
  score, word_to_score, word_count = sentiment_scorer.score
  normalised_score = 0
  normalised_score = score/Float(word_count) if(word_count > 0)
  {:score=>score, :word_to_score=>word_to_score, 
    :word_count=>word_count, :normalised_score=>normalised_score, 
    :page_url=>ps.website, :err=>err}
end

post "/asynch" do
  website = params['website']
  res = process_webpage(website)
  @score = res[:score]
  @word_to_score = res[:word_to_score]
  @word_count = res[:word_count]
  @normalised_score = res[:normalised_score]
  @page_url = res[:page_url]
  @err = res[:err]
  haml :display_sentiment
end

post "/" do 
  website = params['website']
  res = process_webpage(website)
  
  @score = res[:score]
  @word_to_score = res[:word_to_score]
  @word_count = res[:word_count]
  @normalised_score = res[:normalised_score]
  @page_url = res[:page_url]
  @err = res[:err]
  haml :index
end