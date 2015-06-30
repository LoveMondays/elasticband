module Elasticband
  module Filter
    class Base
      def to_h
        raise NotImplementedError
      end
    end
  end
end
