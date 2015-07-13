module Elasticband
  class Aggregation
    class Nested < Aggregation
      attr_accessor :root_aggregation, :nested_aggregations

      def initialize(root_aggregation, nested_aggregations)
        self.root_aggregation = root_aggregation
        self.nested_aggregations = Array.wrap(nested_aggregations)
      end

      def to_h
        root_aggregation.to_h.tap do |h|
          h[root_aggregation.name].merge!(aggs: nested_hash)
        end
      end

      private

      def nested_hash
        self.class.merge(*nested_aggregations)
      end
    end
  end
end
