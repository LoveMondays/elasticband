module Elasticband
  class Filter
    class Near < Filter
      attr_accessor :on, :latitude, :longitude, :distance

      def initialize(on: :location, latitude: nil, longitude: nil, distance: '100km')
        self.on = on
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
      end

      def to_h
        {
          geo_distance: {
            on => { lat: latitude, lon: longitude },
            distance: distance
          }
        }
      end
    end
  end
end
