module Elasticband
  class Query
    class ScoreFunction
      class Filtered < ScoreFunction
        attr_accessor :filter, :score_function, :options

        def initialize(filter, score_function, options = {})
          self.filter = filter
          self.score_function = score_function
          self.options = options
        end

        def to_h
          { filter: filter.to_h }.merge!(score_function.to_h).merge(options)
        end
      end
    end
  end
end
