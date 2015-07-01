module Elasticband
  class Aggregation
    class Nested < Aggregation
      attr_accessor :root_aggregation, :nested_aggregation

      def initialize(root_aggregation, nested_aggregation)
        self.root_aggregation = root_aggregation
        self.nested_aggregation = nested_aggregation
      end

      def to_h
        root_aggregation.to_h.tap do |h|
          h[:aggs][root_aggregation.name].merge!(nested_aggregation.to_h)
        end
      end
    end
  end
end
