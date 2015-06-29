module Elasticband
  module Filter
    class Terms
      attr_accessor :filters, :field, :options

      def initialize(filters, field, options = {})
        self.filters = Array.wrap(filters)
        self.field = field.to_sym
        self.options = options
      end

      def to_h
        { terms: filter_hash }
      end

      private

      def filter_hash
        { field => filters }.merge!(options)
      end
    end
  end
end
