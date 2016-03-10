module Elasticband
  class Filter
    class Exists < Filter
      attr_accessor :field

      def initialize(field)
        self.field = field.to_sym
      end

      def to_h
        { exists: { field: field } }
      end
    end
  end
end
