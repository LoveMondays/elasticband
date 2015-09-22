module Elasticband
  class Search
    class << self
      # Parses a query text with options to a Elasticsearch search syntax.
      # See Elasticband::Query.parse and Elasticband::Aggregation.parse options for details.
      #
      # #### Examples
      # ```
      # Search.parse('foo', on: :name, group_by: :status)
      # => {
      #      query: { match: { name: 'foo' } },
      #      aggs: { status: { terms: { field: :status } } },
      #      sort: [{name: 'desc'}, '+created_at']
      #    }
      # ```
      def parse(query_text, options)
        {
          sort: Sort.parse(options),
          query: Query.parse(query_text, options),
          aggs: Aggregation.parse(options)
        }.reject { |_, value| value.blank? }
      end
    end
  end
end
