module Elasticband
  module Query
    class Base
      attr_accessor :query

      def initialize(query)
        self.query = query
      end
    end
  end
end
