require 'elasticband/filter/and'
require 'elasticband/filter/not'
require 'elasticband/filter/query'
require 'elasticband/filter/term'
require 'elasticband/filter/terms'

module Elasticband
  class Filter
    def to_h
      { match_all: {} }
    end
  end
end
