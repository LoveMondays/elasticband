module Elasticband
  class Query
    class ScoreFunction
      class ScoreMode < ScoreFunction
        attr_accessor :mode

        MODES = %i(multiply mult sum avg first max min).freeze

        def initialize(mode = nil)
          self.mode = mode
        end

        def to_h
          return {} unless mode && MODES.include?(mode)

          { score_mode: mode }
        end
      end
    end
  end
end
