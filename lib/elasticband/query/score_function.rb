require 'elasticband/query/score_function/boost_factor'
require 'elasticband/query/score_function/field_value_factor'
require 'elasticband/query/score_function/filtered'

module Elasticband
  class Query
    class ScoreFunction
      def to_h
        {}
      end
    end
  end
end
