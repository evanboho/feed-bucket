class Ridemap < ActiveRecord::Base
  
  acts_as_gmappable # :lat => 'latitude', :lng => 'longitude'
  
  attr_accessible :end_city, :end_lat, :end_long, :end_state, :latitude, :longitude, :start_city, :start_state
  
  geocoded_by :end_address, :latitude => :end_lat, :longitude => :end_long
  
  before_save :geocode
  
  def start_address
    "#{self.start_city}, #{self.start_state}"
  end
  
  def end_address
    "#{self.end_city}, #{self.end_state}"
  end
  
  def gmaps4rails_address
    "#{self.start_city}, #{self.start_state}"
  end
  
  
  
  def self.clean_up_coords
    require Gmaps4Rails
    Ridemap.all.each do |ridemap|
      coords = ::Gmaps4Rails.geocode("#{ridemap.start_city}, #{ridemap.start_state}")
      if ridemap.latitude != coords[:lat] || ridemap.longitude != coords[:lng]
        ridemap.update_attributes(:latitude => coords[:lat], :longitude => coords[:lng])
      end
      coords = ::Gmaps4Rails.geocord("#{ridemap.end_city}, #{ridemap.end_state}")
      if ridemap.end_lat != coords[:lat] || ridemap.end_long != coords[:lng]
        ridemap.update_attributes(:end_lat => coords[:lat], :end_long => coords[:lng])
      end
    end
  end
  
end
