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
      # * `only:` Filter the search results where the condition is `true`
      # * `except`: Filter the search results where the condition is `false`.
      # * `boost_by:` Boosts the score of a query result based on a attribute of the document.
      #   This score will be multiplied for the `boost_by` attribute over function `ln2p`.
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
      # Query.parse('foo', boost_by: :contents_count)
      # => { function_score: { query: ..., field_value_factor: { field: :contents_count, modifier: :ln2p } } }
      # ```
      def parse(query_text, options = {})
        query = parse_on(query_text, options[:on])
        query = parse_only_and_except(query, options[:only], options[:except])
        query = parse_boost(query, options[:boost_by])
        query.to_h
      end

      private

      def to_dotted_notation(hash_params, prefix = nil, dotted_hash = {})
        hash_params.each_with_object(dotted_hash) do |(key, val), hash|
          if val.is_a?(Hash)
            to_dotted_notation(val, "#{prefix}#{key}.", hash)
          else
            hash["#{prefix}#{key}"] = val
          end
        end
      end

      def parse_on(query_text, on_options)
        if on_options.is_a?(Enumerable)
          Query::MultiMatch.new(query_text, on_options)
        else
          Query::Match.new(query_text, on_options)
        end
      end

      def parse_only_and_except(query, only_options, except_options)
        return query if only_options.blank? && except_options.blank?

        filter = parse_filters(only_options) + parse_filters(except_options).map { |f| Filter::Not.new(f) }
        filter = filter.count > 1 ? Filter::And.new(filter) : filter.first

        Query::Filtered.new(filter, query)
      end

      def parse_filters(options)
        return [] if options.blank?

        to_dotted_notation(options).map { |attribute, value| parse_filter(attribute, value) }
      end

      def parse_filter(attribute, value)
        if value.is_a?(Enumerable)
          Filter::Terms.new(value, attribute)
        else
          Filter::Term.new(value, attribute)
        end
      end

      def parse_boost(query, boost_by_options)
        return query if boost_by_options.blank?

        function = ScoreFunction::FieldValueFactor.new(boost_by_options, modifier: :ln2p)

        Query::FunctionScore.new(query, function)
      end
    end
  end
end
