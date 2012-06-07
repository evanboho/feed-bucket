class RidesController < ApplicationController

  def index
    @rides = Ride.order('created_at desc')
  end
  
  def get_new_cities
    cities = Ride.cities
    cities.each do |city|
      feed = Ride.parse_from_feed("http://#{city}.craigslist.org/rid/index.rss")
    end
    render 'index'
  end
  

end
