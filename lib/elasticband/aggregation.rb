require 'elasticband/aggregation/nested'
require 'elasticband/aggregation/terms'

module Elasticband
  class Aggregation
    attr_accessor :name

    def initialize(name)
      self.name = name.to_sym
    end

    def to_h(aggregation_hash = {})
      { aggs: { name => aggregation_hash } }
    end
  end
end
