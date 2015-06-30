module Elasticband
  module Filter
    class Not < Base
      attr_accessor :other_filter, :options

      def initialize(other_filter, options = {})
        self.other_filter = other_filter
        self.options = options
      end

      def to_h
        { not: filter_hash }
      end

      private

      def filter_hash
        return other_filter.to_h if options.blank?

        { filter: other_filter.to_h }.merge!(options)
      end
    end
  end
end
