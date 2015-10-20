module Elasticband
  class Query
    class ScoreFunction
      class GeoLocation < Gauss
        def initialize(options)
          return unless options.present?

          origin = { lat: options[:latitude], lon: options[:longitude] }
          distance = options[:distance]
          location = { origin: origin, offset: distance[:same_score], scale: distance[:half_score] }
          field = options[:on] || :location

          super(field => location)
        end
      end
    end
  end
end
