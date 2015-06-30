module Elasticband
  module Filter
    class Term < Base
      attr_accessor :filter, :field, :options

      def initialize(filter, field, options = {})
        self.filter = filter
        self.field = field.to_sym
        self.options = options
      end

      def to_h
        { term: filter_hash }
      end

      private

      def filter_hash
        { field => filter }.merge!(options)
      end
    end
  end
end
