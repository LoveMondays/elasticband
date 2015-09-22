module Elasticband
  class Sort
    class << self
      # Parses sort option to a Elasticsearch syntax.
      #
      # #### Options
      #
      # * `sort:` List of sort params.
      #
      # #### Examples
      # ```
      # Sort.parse(sort: [{ name: :desc }])
      # => { sort: [{ name: :desc }] }
      #
      # Sort.parse(sort: [{ name: :asc }])
      # => { sort: [{ name: :asc }] }
      #
      # Sort.parse(sort: ['+name'])
      # => { sort: [{ name: :asc }] }
      #
      # Sort.parse(sort: ['-name'])
      # => { sort: [{ name: :desc }] }
      # ```
      def parse(options)
        options[:sort].map { |param| parse_param(param) }
      end

      private

      def parse_param(param)
        return param unless param.is_a?(String)

        direction = param.start_with?('-') ? :desc : :asc
        field = param.start_with?('-') || param.start_with?('+') ? param[1..-1] : param

        { field.to_sym => direction }
      end
    end
  end
end
