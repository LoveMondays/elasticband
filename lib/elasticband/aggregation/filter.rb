module Elasticband
  class Aggregation
    class Filter < Aggregation
      attr_accessor :filter, :options

      def initialize(name, filter, options = {})
        super(name)
        self.filter = filter
        self.options = options
      end

      def to_h
        super(aggregation_hash)
      end

      private

      def aggregation_hash
        { filter: filter.to_h }.merge!(options)
      end
    end
  end
end
