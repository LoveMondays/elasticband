module Elasticband
  module Filter
    class Query
      attr_accessor :query, :options

      def initialize(query, options = {})
        self.query = query
        self.options = options
      end

      def to_h
        return query_hash if options.blank?

        { fquery: query_hash.merge!(options) }
      end

      private

      def query_hash
        { query: query.to_h }
      end
    end
  end
end
