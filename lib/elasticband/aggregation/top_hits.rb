module Elasticband
  class Aggregation
    class TopHits < Aggregation
      attr_accessor :size, :options

      def initialize(name, size, options = {})
        super(name)
        self.size = size
        self.options = options
      end

      def to_h
        super(top_hits_hash)
      end

      private

      def top_hits_hash
        { top_hits: { size: size }.merge!(options) }
      end
    end
  end
end
