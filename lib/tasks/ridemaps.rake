desc "Check coordinates in db"
task :clean_up_coords => :environment do 
  include Gmaps4Rails
  Ridemap.all.each do |ridemap|
    coords = Gmaps4Rails.geocode("#{ridemap.start_city}, #{ridemap.start_state}")
    if ridemap.latitude != coords[:lat] || ridemap.longitude != coords[:lng]
      ridemap.update_attributes(:latitude => coords[:lat], :longitude => coords[:lng])
    end
    coords = Gmaps4Rails.geocord("#{ridemap.end_city}, #{ridemap.end_state}")
    if ridemap.end_lat != coords[:lat] || ridemap.end_long != coords[:lng]
      ridemap.update_attributes(:end_lat => coords[:lat], :end_long => coords[:lng])
    end
  end
end