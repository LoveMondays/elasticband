module Elasticband
  class Aggregation
    class Max < FieldBased
      def type
        :max
      end
    end
  end
end
