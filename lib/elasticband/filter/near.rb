module Elasticband
  class Filter
    class Near < Filter
      attr_accessor :on, :latitude, :longitude, :distance, :type

      def initialize(on: :location, latitude: nil, longitude: nil, distance: '100km', type: :arc)
        self.on = on
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
        self.type = type
      end

      def to_h
        {
          geo_distance: {
            on => { lat: latitude, lon: longitude },
            distance: distance,
            distance_type: type
          }
        }
      end
    end
  end
end
