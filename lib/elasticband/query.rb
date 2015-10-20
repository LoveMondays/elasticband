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
      # * `boost_mode:` Defines how the function_score will be used.
      # * `score_mode:` Defines how the query score will be used.
      # * `geo_location:` Defines query by geo location.
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
      # Query.parse('foo', boost_function: ..., boost_mode: :multiply)
      # => { function_score: { query: ..., boost_mode: :multiply, script_score: { script: ... } } }
      #
      # Query.parse('foo', boost_function: ..., score_mode: :multiply)
      # => { function_score: { query: ..., score_mode: :multiply, script_score: { script: ... } } }
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
      #
      # Query.parse(
      #   'foo',
      #   geo_location: {
      #     on: :location,
      #     latitude: 12,
      #     longitude: 34,
      #     distance: { same_score: '5km', half_score: '10km' }
      #   }
      # )
      # => {
      #      function_score: {
      #        query: ...,
      #        gauss: { location: { origin: { lat: 12, lon: 34 }, offset: '5km', scale: '10km' } } } }
      # ```
      def parse(query_text, options = {})
        query = parse_on(query_text, options[:on])
        query = parse_query_filters(query, options)
        query = parse_boost(
          query,
          options[:geo_location],
          options.slice(:boost_by, :boost_where, :boost_function),
          options[:score_mode],
          options[:boost_mode]
        )
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

      def parse_boost(query, geo_location_options, boost_options, score_mode_option, boost_mode_option)
        return query if boost_options.blank? && geo_location_options.blank?

        functions = score_functions(geo_location_options, boost_options)
        score_mode = Query::ScoreFunction::ScoreMode.new(score_mode_option)
        boost_mode = Query::ScoreFunction::BoostMode.new(boost_mode_option)

        Query::FunctionScore.new(query, functions, score_mode, boost_mode)
      end

      def score_functions(geo_location_options, boost_options)
        functions = []
        functions << Query::ScoreFunction::GeoLocation.new(geo_location_options) if geo_location_options
        functions << parse_boost_function(boost_options) if boost_options.present?
        functions
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
