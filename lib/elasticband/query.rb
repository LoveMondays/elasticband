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

    class << self
      # Parses a query text with options to a Elasticsearch syntax
      #
      # #### Examples
      # ```
      # Query.parse('foo')
      # => { match: { _all: 'foo' } }
      # ```
      def parse(query, options = {})
        return Match.new(query).to_h if options.blank?
      end
    end
  end
end
