require 'elasticband/filter/and'
require 'elasticband/filter/exists'
require 'elasticband/filter/not'
require 'elasticband/filter/query'
require 'elasticband/filter/range'
require 'elasticband/filter/near'
require 'elasticband/filter/term'
require 'elasticband/filter/terms'
require 'elasticband/filter/script'

module Elasticband
  class Filter
    PARSE_FILTERS = %i(only except exists includes range near).freeze

    def to_h
      { match_all: {} }
    end

    class << self
      # Parses filter options to a Elasticsearch syntax
      #
      # #### Options
      #
      # * `only:` Filter the search results where the condition is `true`
      # * `except`: Filter the search results where the condition is `false`.
      # * `includes:` Filter the search results with a `Match` query.
      # * `range:` Filter the search results where the condition is on the given range.
      # * `near:` Filter the search results where the results are near a geo point.
      # * `script:` Filter the search results where the results match the script.
      #
      # #### Examples
      # ```
      # Filter.parse(only: { status: :published })
      # => { term: { status: :published } }
      #
      # Filter.parse(exists: :status)
      # => { exists: { field: :status } }
      #
      # Filter.parse(except: { company: { id: 1 } })
      # => { not: { term: { status: :published } } }
      #
      # Filter.parse(includes: ['company', on: :description])
      # => { query: { match: { description: 'company' } } }
      #
      # Filter.parse(range: { companies_count: { gt: 1, gteq: 1, lt: 1, lteq: 1 } })
      # => { range: { companies_count: { gt: 1, gte: 1, lt: 1, lte: 1 } } }
      #
      # Filter.parse(near: { latitude: 12, longitude: 34, distance: '5km', type: :arc })
      # => { geo_distance: { location: { lat: 12, lon: 34 } }, distance: '5km', distance_type: :arc }
      #
      # Filter.parse(script: ['(param1 + param2) > 0', param1: 1, param2: 1])
      # => { script: { script: '(param1 + param2) > 0', params: { param1: 1, param2: 1 } } }
      # ```
      def parse(options = {})
        return {} if options.blank?

        filters = map_filters(options)

        join_filters(filters).to_h
      end

      private

      def map_filters(options)
        filters = only_and_except_filters(options[:only], options[:except])
        filters += exists_filter(options[:exists])
        filters += includes_filter(options[:includes])
        filters += range_filter(options[:range])
        filters += near_filter(options[:near])
        filters += script_filter(options[:script])

        filters
      end

      def only_and_except_filters(only_options, except_options)
        parse_filters(only_options) + parse_filters(except_options).map { |f| Filter::Not.new(f) }
      end

      def join_filters(filters)
        filters.count > 1 ? Filter::And.new(filters) : filters.first
      end

      def exists_filter(exists_options)
        return [] if exists_options.blank?

        [Filter::Exists.new(exists_options)]
      end

      def includes_filter(includes_options)
        return [] if includes_options.blank?

        [Filter::Query.new(Elasticband::Query.parse(*includes_options))]
      end

      def range_filter(range_options)
        return [] if range_options.blank?

        [Filter::Range.new(range_options.keys.first, range_options.values.first)]
      end

      def near_filter(options)
        return [] if options.blank?

        [Filter::Near.new(options)]
      end

      def script_filter(script_options)
        return [] if script_options.blank?

        [Filter::Script.new(*script_options)]
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

      def to_dotted_notation(hash_params, prefix = nil, dotted_hash = {})
        hash_params.each_with_object(dotted_hash) do |(key, val), hash|
          if val.is_a?(Hash)
            to_dotted_notation(val, "#{prefix}#{key}.", hash)
          else
            hash["#{prefix}#{key}"] = val
          end
        end
      end
    end
  end
end
