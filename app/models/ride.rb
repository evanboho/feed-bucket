class Ride < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper  
  require 'RSS'
  require 'open-uri'
  
  validates_uniqueness_of :guid
  validates_presence_of :url, :title
  
  attr_accessible :body, :guid, :title, :url, :cl_city, :published_at, :email
  
  before_validation :strip_tags_from_body
  validate :not_in_all_caps
  validate :no_limos_or_taxis
  validate :body_does_not_have_reply_to
  
  def not_in_all_caps
    if self.body.to(20) == self.body.to(20).upcase
      errors.add(:body, "can't be in all caps")
    end
  end
  def no_limos_or_taxis
    if self.body.downcase.include?("limo") || self.body.downcase.include?("taxi")
      errors.add(:body, "can't have limos or taxis")
    end
  end
  def body_does_not_have_reply_to
    if self.body.include?("Reply to:")
      errors.add(:body, "includes reply to.")
    end
  end
  
  def strip_tags_from_body
    self.body = strip_tags(self.body.split("<!--").first) 
    self.body = self.body.gsub("\n", ' ').split("Location: ").first
  end
  
  
  def self.parse_from_all_cities_from_feed
    cities.each do |city|
      Ride.parse_from_feed("http://#{city}.craigslist.org/rid/index.rss")
    end    
  end
  
  def self.parse_from_feed(feed_url)
    feed = RSS::Parser.parse(open(feed_url))
    feed.items.each do |item|
      Ride.find_or_create_from_feed(item, city(feed.channel))
    end
  end
  
  def self.find_or_create_from_feed(item, city)
    unless exists? :guid => guid(item)
      Ride.create(
          :guid => guid(item), 
          :url => item.link, 
          :title => item.title, 
          :body => item.description, 
          :cl_city => city, 
          :published_at => item.date)
    end
  end
  
  def self.scrape_emails
    ride = Ride.all
    ride.each do |ride| 
      if ride.email.nil?
        doc = Nokogiri::HTML(open(ride.url))
        ride.email = doc.css('.returnemail a').text if doc.css('.returnemail a').text.split('@').count == 2
        if ride.email.nil?
          doc.css('a').each do |a|
            ride.email = a.text if a.text.split('@').count == 2 
          end
        end
        ride.save if ride.changed?
      end
    end
  end
  
  def self.ensure_need_or_want
    Ride.all.each do |ride|
      unless 
        # ( ride.title.downcase.include?('to') || ride.body.downcase.include?('to') )     ||
        ( ride.title.downcase.include?('offer') || ride.body.downcase.include?('offer') ) ||
        ( ride.title.downcase.include?('need') || ride.body.downcase.include?('need') ) ||
        ( ride.title.downcase.include?('want') || ride.body.downcase.include?('want'))
        if ride.body.downcase.include?('rate')
          if ride.body == ride.body.upcase
            ride.destroy
          end
        end
      end
    end 
  end
  
  def self.destroy_all_caps
    Ride.all.each do |ride|
      if ride.body.to(20) == ride.body.to(20).upcase
        ride.destroy
      elsif ride.title.to(10) == ride.title.to(10).upcase
        ride.destroy
      elsif ride.body.include?("Reply to: your")
        ride.destroy
      else
        ride.save
      end
    end
  end
    
  
  private
  
  def self.guid(item)
    item.link.split('/')[5].split('.').first
  end
  
  def self.city(channel)
    channel.link.split('/')[2].split('.').first
  end
  
  def self.cities
    ["chicago", "boston", "newyork", "atlanta"]
  end
  
end
