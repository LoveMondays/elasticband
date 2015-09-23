require 'elasticband/aggregation/field_based'
require 'elasticband/aggregation/filter'
require 'elasticband/aggregation/max'
require 'elasticband/aggregation/nested'
require 'elasticband/aggregation/terms'
require 'elasticband/aggregation/top_hits'

module Elasticband
  class Aggregation
    PARSE_AGGREGATIONS = %i(group_by group_max top_hits group_by_filter)

    attr_accessor :name

    def initialize(name)
      self.name = name.to_s.gsub(/\W/, '_'.freeze).to_sym
    end

    def to_h(aggregation_hash = {})
      { name => aggregation_hash }
    end

    class << self
      # Parses some options to a Elasticsearch syntax, aggregations can be nested in another.
      #
      # #### Options
      #
      # * `group_by:` Count results by the value of an attribute using `terms` filter.
      #   It can receive an array with some attributes:
      #   * `size:` Size of the results calculated in each shard (https://www.elastic.co/guide/en/elasticsearch/reference/1.x/search-aggregations-bucket-terms-aggregation.html#_size)
      #   * `script:` Generates terms defined by the script
      # * `group_max:` Group results by maximum value of a field
      #   It can receive an array with some attributes:
      #   * `script:` Generates max defined by the script
      # * `top_hits:` A number of results that should be return inside the group ranked by score.
      # * `group_by_filter:` Filter and group results with a name using Elasticband::Filter.parse options
      #
      # #### Examples
      # ```
      # Aggregation.parse(group_by: :status)
      # => { status: { terms: { field: :status } } }
      #
      # Aggregation.parse(group_max: :contents_count)
      # => { status: { max: { field: :contents_count } } }
      #
      # Aggregation.parse(group_by: [:status, size: 5, top_hits: 3])
      # => { status: { terms: { field: :status, size: 5 }, aggs: { top_status: { top_hits: 3 } } } }
      #
      # Aggregation.parse(group_by_filter: [:published_results, only: { status: :published }])
      # => { published_results: { filter: { term: { status: :published } } } }
      # ```
      def parse(options)
        merge(*parse_aggregations(options))
      end

      def merge(*aggregations)
        aggregations.each_with_object({}) { |a, h| h.merge!(a.to_h) }
      end

      private

      def parse_aggregations(options, root_aggregation = nil)
        parse_options = options.slice(*PARSE_AGGREGATIONS)
        return root_aggregation if parse_options.blank?

        aggregations = parse_options.map do |aggregation_name, aggregation_options|
          parse_singular_aggregation(root_aggregation, aggregation_name, aggregation_options)
        end

        aggregations = Aggregation::Nested.new(root_aggregation, aggregations) if root_aggregation
        aggregations
      end

      def parse_singular_aggregation(root_aggregation, aggregation_name, aggregation_options)
        case aggregation_name
        when :group_by then parse_field_aggregation(Aggregation::Terms, :by, aggregation_options)
        when :group_max then parse_field_aggregation(Aggregation::Max, :max, aggregation_options)
        when :top_hits then parse_top_hits(root_aggregation, aggregation_options)
        when :group_by_filter then parse_filter(*aggregation_options)
        end
      end

      def parse_field_aggregation(aggregation_class, prefix, options_aggregation)
        return {} if options_aggregation.blank?

        field, options = options_aggregation
        options ||= {}

        name = :"#{prefix}_#{field}"
        aggregation = aggregation_class.new(name, field, options.except(*PARSE_AGGREGATIONS))
        parse_aggregations(options, aggregation)
      end

      def parse_top_hits(root_aggregation, options_top_hits)
        return {} if options_top_hits.blank?

        size, options = options_top_hits
        options ||= {}

        name = :"top_#{root_aggregation.name}"
        aggregation = Aggregation::TopHits.new(name, size, options.except(*PARSE_AGGREGATIONS))
        parse_aggregations(options, aggregation)
      end

      def parse_filter(aggregation_name, options)
        return {} if options.blank?

        filter = Elasticband::Filter.parse(options)
        filter_options = options.except(*(PARSE_AGGREGATIONS + Elasticband::Filter::PARSE_FILTERS))
        aggregation = Aggregation::Filter.new(aggregation_name, filter, filter_options)
        parse_aggregations(options, aggregation)
      end
    end
  end
end
