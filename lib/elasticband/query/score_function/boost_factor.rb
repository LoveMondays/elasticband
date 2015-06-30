module Elasticband
  module Query
    module ScoreFunction
      class BoostFactor
        attr_accessor :boost

        def initialize(boost)
          self.boost = boost
        end

        def to_h
          { boost_factor: boost }
        end
      end
    end
  end
end
