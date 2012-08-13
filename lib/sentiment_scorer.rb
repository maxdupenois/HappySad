#!/usr/bin/env ruby
require 'set'

require File.join(File.dirname(__FILE__), *%w[porter_stemmer])

class String
  def clean_stem
    w = self.strip
    w.gsub!(/[^a-zA-Z]*/, "")
    w = w.stem
    w.downcase!
    w
  end
  def valid_word?
    self =~ /[a-z]{3,}/
  end
end

def read_word_file(file)
  words = Set.new
  File.open(File.join(File.dirname(__FILE__), file), "r") do |infile|
    w=nil
    words.add(w.clean_stem) while(w = infile.gets) 
  end
  words
end

HAPPY = read_word_file("happy_words.txt")
SAD = read_word_file("sad_words.txt")
STOP = read_word_file("stop_words.txt")


class SentimentScorer
  def initialize(page)
    @page = page
  end
  
  def word_score(w)
    return 1 if(HAPPY.include?(w))
    return -1 if(SAD.include?(w))
    return 0
  end
  def process_section(section, multiplier)
    current = 0
    wc = 0
    word_scores = Hash.new{|h,k| h[k] = 0}
    section.each {|part| part.split(" ").each { |w| 
      clean_word = w.clean_stem
      next if(!clean_word.valid_word?)
      sc = word_score(clean_word) * multiplier
      word_scores[clean_word] += sc if(sc != 0)
      current += sc
      wc += sc.abs
      # wc += 1 if(!STOP.include?(clean_word))
      # puts "Word: #{clean_word}" if(!STOP.include?(clean_word))
      }}
    
    {:score => current, :word_to_score => word_scores, :word_count => wc}
  end
  def score
    current = 0
    wc = 0
    word_to_score = Hash.new{|h, k| h[k] = 0}
    return [current, word_to_score, wc] if(@page.nil?)
    sections = [[@page[:content], 1], [@page[:highlighted], 2], [@page[:headline], 3]]
    sections.each do |sect|
      res = process_section(sect[0], sect[1])
      res[:word_to_score].keys.each{|k| word_to_score[k] += res[:word_to_score][k]}
      current += res[:score]
      wc += res[:word_count]
    end
    [current, word_to_score, wc]
  end
end

if __FILE__ == $0
  require File.join(File.dirname(__FILE__), *%w[page_scraper])
  page = PageScraper.new("bbc.co.uk").scrape
  score, word_to_score = SentimentScorer.new(page).score
  puts score
  puts word_to_score
end