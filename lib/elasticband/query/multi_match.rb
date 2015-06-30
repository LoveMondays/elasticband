module Elasticband
  module Query
    class MultiMatch < Base
      attr_accessor :query, :fields, :options

      def initialize(query, fields = [:_all], options = {})
        self.query = query
        self.fields = Array.wrap(fields).map(&:to_sym)
        self.options = options
      end

      def to_h
        { multi_match: query_hash }
      end

      private

      def query_hash
        { query: query }.merge!(options).merge!(fields: fields)
      end
    end
  end
end
