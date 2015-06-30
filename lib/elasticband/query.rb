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
      # #### Options
      #
      # * `on:` Defines which attributes will searched in documents
      #
      # #### Examples
      # ```
      # Query.parse('foo')
      # => { match: { _all: 'foo' } }
      #
      # Query.parse('foo', on: :name)
      # => { match: { name: 'foo' } }
      #
      # Query.parse('foo', on: %i(name description))
      # => { multi_match: { query: 'foo', fields: [:name, :description]  } }
      # ```
      def parse(query, options = {})
        return Match.new(query).to_h if options.blank?

        if options[:on]
          if options[:on].is_a?(Enumerable)
            MultiMatch.new(query, options[:on]).to_h
          else
            Match.new(query, options[:on]).to_h
          end
        end
      end
    end
  end
end
