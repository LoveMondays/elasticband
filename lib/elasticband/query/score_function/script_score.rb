module Elasticband
  class Query
    class ScoreFunction
      class ScriptScore < ScoreFunction
        attr_accessor :script, :options

        def initialize(script, options = {})
          self.script = script
          self.options = options
        end

        def to_h
          { script_score: script_score_hash }
        end

        private

        def script_score_hash
          { script: script }.merge!(options)
        end
      end
    end
  end
end
