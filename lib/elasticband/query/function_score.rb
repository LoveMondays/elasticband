module Elasticband
  class Query
    class FunctionScore < Query
      attr_accessor :query_or_filter, :function, :score_mode, :boost_mode

      def initialize(query_or_filter, function, score_mode, boost_mode)
        self.query_or_filter = query_or_filter
        self.function = function
        self.score_mode = score_mode
        self.boost_mode = boost_mode
      end

      def to_h
        { function_score: function_score_hash }
      end

      private

      def function_score_hash
        query_or_filter_hash.merge!(function_hash).merge(score_mode.to_h).merge(boost_mode.to_h)
      end

      def query_or_filter_hash
        if query_or_filter.is_a?(Query)
          { query: query_or_filter.to_h }
        else
          { filter: query_or_filter.to_h }
        end
      end

      def function_hash
        if function.is_a?(Enumerable)
          function.size > 1 ? { functions: function.map(&:to_h) } : single_function_hash(function.first)
        else
          single_function_hash(function)
        end
      end

      def single_function_hash(function)
        function_hash = function.to_h
        function_hash.key?(:filter) ? { functions: [function_hash] } : function_hash
      end
    end
  end
end
