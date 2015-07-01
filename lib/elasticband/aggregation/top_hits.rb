module Elasticband
  class Aggregation
    class TopHits < Aggregation
      attr_accessor :root_aggregation, :size, :from, :options

      def initialize(name, root_aggregation, size, options = {})
        super(name)
        self.root_aggregation = root_aggregation
        self.size = size
        self.options = options
      end

      def to_h
        root_aggregation.to_h.tap do |h|
          h[:aggs][root_aggregation.name].merge!(super(top_hits_hash))
        end
      end

      private

      def top_hits_hash
        { size: size }.merge!(options)
      end
    end
  end
end
