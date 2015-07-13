module Elasticband
  class Aggregation
    class FieldBased < Aggregation
      attr_accessor :field, :options

      def initialize(name, field, options = {})
        super(name)
        self.field = field && field.to_sym
        self.options = options
      end

      def to_h
        super(aggregation_hash)
      end

      def type
        fail NotImplementedError
      end

      private

      def aggregation_hash
        { type => { field: field }.merge!(options).compact }
      end
    end
  end
end
