require 'elasticband/aggregation/nested'
require 'elasticband/aggregation/terms'
require 'elasticband/aggregation/top_hits'

module Elasticband
  class Aggregation
    attr_accessor :name

    def initialize(name)
      self.name = name.to_sym
    end

    def to_h(aggregation_hash = {})
      { name => aggregation_hash }
    end
  end
end
