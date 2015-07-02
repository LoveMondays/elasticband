module Elasticband
  class Search
    class << self
      # Parses a query text with options to a Elasticsearch search syntax.
      # See Elasticband::Query.parse and Elasticband::Aggregation.parse options for details.
      #
      # #### Examples
      # ```
      # Search.parse('foo', on: :name, group_by: :status)
      # => { query: { match: { name: 'foo' } }, aggr: { status: { terms: { field: :status } } } }
      # ```
      def parse(query_text, options)
        { query: Query.parse(query_text, options), aggr: Aggregation.parse(options) }
      end
    end
  end
end
