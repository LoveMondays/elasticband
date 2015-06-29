module Elasticband
  module Filter
    class Term
      attr_accessor :filter, :field, :options

      def initialize(filter, field, options = {})
        self.filter = filter
        self.field = field.to_sym
        self.options = options
      end

      def to_h
        { term: { field => filter }.merge!(options) }
      end
    end
  end
end
