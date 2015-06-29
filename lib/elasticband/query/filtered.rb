module Elasticband
  module Query
    class Filtered
      attr_accessor :query, :filter, :options

      def initialize(filter, query = nil, options = {})
        self.filter = filter
        self.query = query
        self.options = options
      end

      def to_h
        { filtered: query_hash }
      end

      private

      def query_hash
        return { filter: filter.to_h }.merge!(options) if query.blank?

        { query: query.to_h, filter: filter.to_h }.merge!(options)
      end
    end
  end
end
