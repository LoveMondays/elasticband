module Elasticband
  module Filter
    class And < Base
      attr_accessor :filters, :options

      def initialize(filters, options = {})
        self.filters = Array.wrap(filters)
        self.options = options
      end

      def to_h
        { and: filter_hash }
      end

      private

      def filter_hash
        return filters.map(&:to_h) if options.blank?

        { filter: filters.map(&:to_h) }.merge!(options)
      end
    end
  end
end
