module Elasticband
  module Query
    class Base
      def to_h
        raise NotImplementedError
      end
    end
  end
end
