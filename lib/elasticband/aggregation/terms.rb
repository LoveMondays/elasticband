module Elasticband
  class Aggregation
    class Terms < Aggregation
      attr_accessor :field, :options

      def initialize(name, field, options = {})
        super(name)
        self.field = field.to_sym if field
        self.options = options
      end

      def to_h
        super(aggregation_hash)
      end

      private

      def aggregation_hash
        { terms: { field: field }.merge!(options).compact }
      end
    end
  end
end
