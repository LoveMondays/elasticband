module Elasticband
  class Query
    class ScoreFunction
      class Gauss < ScoreFunction
        attr_accessor :options

        def initialize(options)
          self.options = options
        end

        def to_h
          return {} unless options

          { gauss: options }
        end
      end
    end
  end
end
