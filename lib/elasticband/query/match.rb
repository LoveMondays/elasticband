module Elasticband
  class Query
    class Match < Query
      attr_accessor :query, :field, :options

      def initialize(query, field = nil, options = {})
        self.query = query
        self.field = (field || :_all).to_sym
        self.options = options
      end

      def to_h
        { match: { field => query_hash } }
      end

      private

      def query_hash
        return query if options.blank?

        { query: query }.merge!(options)
      end
    end
  end
end
