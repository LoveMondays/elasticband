module Elasticband
  class Query
    class ScoreFunction
      class BoostMode < ScoreFunction
        attr_accessor :mode

        MODES = %i(multiply replace sum avg max min).freeze

        def initialize(mode = nil)
          self.mode = mode
        end

        def to_h
          return {} unless mode && MODES.include?(mode)

          { boost_mode: mode }
        end
      end
    end
  end
end
