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
      # Parses a query text with options to a Elasticsearch syntax.
      # Check Elasticband::Filter.parse for filter options.
      #
      # #### Options
      #
      # * `on:` Defines which attributes will searched in documents.
      # * `boost_by:` Boosts the score of a query result based on a attribute of the document.
      #   This score will be multiplied for the `boost_by` attribute over function `ln2p`.
      # * `boost_where:` Boosts the score of a query result where some condition is `true`.
      #   This score will be multiplied by 1000 (arbitrary, based on gem `searchkick`)
      # * `boost_function:` Boosts using the function passed.
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
      # => { multi_match: { query: 'foo', fields: [:name, :description] } }
      #
      # Query.parse('foo', only: { status: :published })
      # => { filtered: { query: ..., filter: { term: { status: :published } } } }
      #
      # Query.parse('foo', except: { company: { id: 1 } })
      # => { filtered: { query: ..., filter: { not: { term: { status: :published } } } } }
      #
      # Query.parse('foo', includes: ['company', on: :description])
      # => { filtered: { query: ..., filter: { query: { match: { description: 'company' } } } } }
      #
      # Query.parse('foo', boost_by: :contents_count)
      # => { function_score: { query: ..., field_value_factor: { field: :contents_count, modifier: :ln2p } } }
      #
      # Query.parse('foo', boost_function: "_score * doc['users_count'].value")
      # => { function_score: { query: ..., script_score: { script: '_score * doc['users_count'].value' } } }
      #
      # Query.parse('foo', boost_where: { company: { id: 1 } })
      # => {
      #      function_score: {
      #        query: ...,
      #        functions: [
      #          { filter: { term: { 'company.id': 1 } }, boost_factor: 1000 }
      #        ]
      #      }
      #    }
      # ```
      def parse(query_text, options = {})
        query = parse_on(query_text, options[:on])
        query = parse_query_filters(query, options)
        query = parse_boost(query, options.slice(:boost_by, :boost_where, :boost_function))
        query.to_h
      end

      private

      def parse_on(query_text, on_options)
        return Query.new if query_text.blank?

        if on_options.is_a?(Enumerable)
          Query::MultiMatch.new(query_text, on_options)
        else
          Query::Match.new(query_text, on_options)
        end
      end

      def parse_query_filters(query, filter_options)
        filter = Filter.parse(filter_options)

        filter.blank? ? query : Query::Filtered.new(filter, query)
      end

      def parse_boost(query, boost_options)
        return query if boost_options.blank?

        function = parse_boost_function(boost_options)
        Query::FunctionScore.new(query, function)
      end

      def parse_boost_function(boost_options)
        if boost_options[:boost_by].present?
          ScoreFunction::FieldValueFactor.new(boost_options[:boost_by], modifier: :ln2p)
        elsif boost_options[:boost_where].present?
          filter = Filter.parse(only: boost_options[:boost_where])
          ScoreFunction::Filtered.new(filter, ScoreFunction::BoostFactor.new(1_000))
        else
          boost_function, boost_function_params = boost_options[:boost_function]
          ScoreFunction::ScriptScore.new(boost_function, boost_function_params || {})
        end
      end
    end
  end
end
