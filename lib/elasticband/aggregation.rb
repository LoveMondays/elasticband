require 'elasticband/aggregation/nested'
require 'elasticband/aggregation/terms'
require 'elasticband/aggregation/top_hits'

module Elasticband
  class Aggregation
    attr_accessor :name

    def initialize(name)
      self.name = name.to_sym
    end

    def to_h(aggregation_hash = {})
      { name => aggregation_hash }
    end

    class << self
      # Parses some options to a Elasticsearch syntax
      #
      # #### Options
      #
      # * `group_by:` Count results by the value of an attribute using `terms` filter.
      #   It can receive an array with some attributes:
      #   * `top_hits:` A number of results that should be return inside the group ranked by score.
      #   * `size:` Size of the results calculated in each shard (https://www.elastic.co/guide/en/elasticsearch/reference/1.x/search-aggregations-bucket-terms-aggregation.html#_size)
      #
      # #### Examples
      # ```
      # Aggregation.parse(group_by: :status)
      # => { status: { terms: { field: :status } } }
      #
      # Aggregation.parse(group_by: [:status, size: 5, top_hits: 3])
      # => { status: { terms: { field: :status, size: 5 }, aggs: { top_status: { top_hits: 3 } } } }
      def parse(options)
        parse_group_by(options[:group_by]).to_h
      end

      private

      def parse_group_by(options_group_by)
        return {} if options_group_by.blank?

        field, options = options_group_by
        options ||= {}

        aggregation = Aggregation::Terms.new(field, field, options.except(:top_hits))
        if options[:top_hits]
          aggregation = Aggregation::TopHits.new(:"top_#{field}", aggregation, options[:top_hits])
        end

        aggregation
      end
    end
  end
end
