module Elasticband
  class Query
    class ScoreFunction
      class BoostFactor < ScoreFunction
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
