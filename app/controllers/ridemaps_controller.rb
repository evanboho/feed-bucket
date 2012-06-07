class RidemapsController < ApplicationController
  
  def index
    if Ridemap.first.present?
      @json = Ridemap.all.to_gmaps4rails
    end 
    # @polylines = Ridemap.last.to_gmaps4rails do |ridemap, marker|
     # marker.json("{\"lat\": #{ridemap.latitude}, \"lng\": #{ridemap.longitude}, " << "\"lat\": #{ridemap.end_lat}, \"lng\": #{ridemap.end_long}}")
        #{ :lat => ridemap.end_lat, :lng => ridemap.end_long }, 
        #{ :lat => ridemap.end_lat, :lng => ridemap.end_long }])
    #end
    @polycoords = []
    Ridemap.all.each do |ridemap|
      @polycoords << {:longitude => "#{ridemap.longitude}", 
                      :latitude => "#{ridemap.latitude}", 
                      :end_long => "#{ridemap.end_long}", 
                      :end_lat => "#{ridemap.end_lat}"}
    end
      
    ridemap = Ridemap.last
    # @polylines = [ { "lat" => ridemap.latitude, "lng" => ridemap.longitude }, { "lat" => ridemap.end_lat, "lng" => ridemap.end_long }.to_json ]
    @ridemap = Ridemap.new
    @ridemaps = Ridemap.all
  end
  
  def gmaps4rails_infowindow
    
  end
  
  def new
    @ridemap = Ridemap.new
  end
  
  def create
    Ridemap.create!(params[:ridemap])
    redirect_to ridemaps_path
  end
  
end
