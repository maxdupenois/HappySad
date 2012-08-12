#!/usr/bin/env ruby
require 'open-uri'
require 'nokogiri'



class PageScraper
  
  def initialize(website)
    website = "http://#{website}" if(not website =~ /^http.*/)
    @website = website
  end
  
  def scrape
    page = open(@website) rescue nil
    
    return nil if(page.nil?)
    Scrapers.default(Nokogiri::HTML(page))
  end

end

class Scrapers
  def self.remove_tags(text)
    text.content.gsub(/<[^>]*>/, "")
  end
  def self.default(doc)
    content = doc.css('p').map{|t| remove_tags(t)}
    highlighted = doc.css('b,i,emph,strong').map{|t| remove_tags(t)}
    headline = doc.css('h1,h2,h3').map{|t| remove_tags(t)}
    return {:content=>content, :highlighted=>highlighted, :headline=>headline}
  end
end

if __FILE__ == $0
  ps = PageScraper.new("http://www.wikihow.com/Be-Happy")
  contents = ps.scrape
  puts contents 
end