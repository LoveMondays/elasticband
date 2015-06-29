module Elasticband
  module Query
    class MultiMatch < Base
      attr_accessor :fields, :options

      def initialize(query, fields = [:_all], options = {})
        super(query)

        self.fields = Array.wrap(fields).map(&:to_sym)
        self.options = options
      end

      def query
        { query: @query }.merge!(options)
      end

      def to_h
        { multi_match: query.merge!(fields: fields) }
      end
    end
  end
end
