module Elasticband
  class Filter
    class Range < Filter
      attr_accessor :field, :ranges

      RANGES = %i(gt gteq lt lteq).freeze

      def initialize(field, ranges)
        self.field = field.to_sym
        self.ranges = permitted_ranges(ranges)
      end

      def to_h
        { range: { field => parsed_ranges } }
      end

      def permitted_ranges(ranges)
        ranges.keep_if { |key, _| RANGES.include?(key) }
      end

      def parsed_ranges
        translated_range = ranges.dup

        translated_range[:gte] = translated_range.delete(:gteq) if translated_range.key?(:gteq)
        translated_range[:lte] = translated_range.delete(:lteq) if translated_range.key?(:lteq)

        translated_range
      end
    end
  end
end
