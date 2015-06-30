module Elasticband
  class Query
    class ScoreFunction
      class FieldValueFactor < ScoreFunction
        attr_accessor :field, :options

        def initialize(field, options = {})
          self.field = field.to_sym
          self.options = options
        end

        def to_h
          { field_value_factor: function_hash }
        end

        private

        def function_hash
          { field: field }.merge!(options)
        end
      end
    end
  end
end
