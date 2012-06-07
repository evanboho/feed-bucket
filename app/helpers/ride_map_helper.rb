module RideMapHelper

  def polycoords_helper
    coords = []
    @polycoords.each do |coord|
       coords << [{:lng => coord[:longitude], :lat => coord[:latitude] },
                   {:lng => coord[:end_long], :lat => coord[:end_lat] }]
    end
    coords.as_json
  end

end
