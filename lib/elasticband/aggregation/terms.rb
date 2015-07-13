module Elasticband
  class Aggregation
    class Terms < FieldBased
      def type
        :terms
      end
    end
  end
end
