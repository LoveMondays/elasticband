module Elasticband
  module Query
    class Match < Base
      attr_accessor :field, :options

      def initialize(query, field = :_all, options = {})
        super(query)

        self.field = field.to_sym
        self.options = options
      end

      def query
        return @query if options.blank?

        { query: @query }.merge!(options)
      end

      def to_h
        { match: { field => query } }
      end
    end
  end
end
