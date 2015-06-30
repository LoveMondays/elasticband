module Elasticband
  class Query
    class FunctionScore < Query
      attr_accessor :query_or_filter, :function, :options

      def initialize(query_or_filter, function, options = {})
        self.query_or_filter = query_or_filter
        self.function = function
        self.options = options
      end

      def to_h
        { function_score: function_score_hash }
      end

      private

      def function_score_hash
        query_or_filter_hash.merge!(function_hash).merge!(options)
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
          { functions: function.map(&:to_h) }
        else
          function_hash = function.to_h
          if function_hash.key?(:filter)
            { functions: [function_hash] }
          else
            function_hash
          end
        end
      end
    end
  end
end
