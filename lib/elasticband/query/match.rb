module Elasticband
  module Query
    class Match < Base
      attr_accessor :field

      def initialize(field, query)
        super(query)

        self.field = field
      end

      def to_h
        { match: { field.to_sym => query } }
      end
    end
  end
end
