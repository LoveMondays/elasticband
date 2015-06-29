module Elasticband
  module Query
    class Match < Base
      attr_accessor :field, :options

      def initialize(field, query, options = {})
        super(query)

        self.field = field
        self.options = options
      end

      def query
        return @query if options.empty?

        { query: @query }.merge!(options)
      end

      def to_h
        { match: { field.to_sym => query } }
      end
    end
  end
end
