module Elasticband
  class Filter
    class Script < Filter
      attr_accessor :script, :params

      def initialize(script, params = {})
        self.script = script
        self.params = params
      end

      def to_h
        return {} unless script

        { script: { script: script }.merge(params_hash) }
      end

      private

      def params_hash
        return {} unless params.any?

        { params: params }
      end
    end
  end
end
