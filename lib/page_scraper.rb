#!/usr/bin/env ruby
require 'set'
require 'open-uri'
require 'nokogiri'

require File.join(File.dirname(__FILE__), *%w[porter_stemmer])

def read_emotive_word_file(file)
  words = []
  File.open(File.join(File.dirname(__FILE__), file), "r") do |infile|
    w=nil
    words << w.strip while(w = infile.gets) 
  end
  words
end

HAPPY = Set.new read_emotive_word_file("happy_words.txt")
HAPPY.map! {|w| w.stem}
SAD = Set.new read_emotive_word_file("sad_words.txt")
SAD.map! {|w| w.stem}

class String
  def clean_stem
    w = self.strip
    w.gsub!(/[^a-zA-Z]*/, "")
    w = w.stem
    w.downcase!
    w
  end
end

class PageScraper
  
  def initialize(website)
    @website = website
  end
  
  def scrape
    page = open(@website) rescue nil
    
    return nil if(page.nil?)
    Scrapers.default(Nokogiri::HTML(page))
  end
  def word_score(w)
    return 1 if(HAPPY.include?(w))
    return -1 if(SAD.include?(w))
    return 0
  end
  def process_section(section, multiplier)
    current = 0
    # puts section
    section.each do |part| 
      # part.each {|p| puts p}
      part.split(" ").each do |w| 
        w = w.clean_stem
        sc =  word_score(w)
        current +=sc
      end
    end
    
    multiplier*current
  end
  def score(contents)
    current = 0
    return current if(contents.nil?)
    current += process_section(contents[:content], 1) if(!contents[:content].nil?)
    puts "Done content"
    current += process_section(contents[:highlighted], 2)  if(!contents[:highlighted].nil?)
    current += process_section(contents[:headline], 3)  if(!contents[:headline].nil?)
    current
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
  # def self.default
  #     Scraper.define do
  #       array :content
  #       array :highlighted
  #       array :headline
  #       process "p", :content=>:text
  #       process "b", :highlighted=>:text
  #       process "i", :highlighted=>:text
  #       process "emph", :highlighted=>:text
  #       process "strong", :highlighted=>:text
  #       process "h1,h2,h3", :headline=>:text
  #       result :content, :headline, :highlighted
  #     end
  #   end
end

if __FILE__ == $0
  ps = PageScraper.new("http://www.wikihow.com/Be-Happy")
  contents = ps.scrape
  score = ps.score(contents)
  puts score
end