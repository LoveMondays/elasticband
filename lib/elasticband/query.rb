require 'elasticband/query/filtered'
require 'elasticband/query/function_score'
require 'elasticband/query/match'
require 'elasticband/query/multi_match'
require 'elasticband/query/score_function'

module Elasticband
  class Query
    def to_h
      { match_all: {} }
    end
  end
end
