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
      # Sort.parse(sort: { name: :desc })
      # => { sort: [{ name: :desc }] }
      #
      # Sort.parse(sort: [{ name: :desc }, { created_at: :asc }])
      # => { sort: [{ name: :desc }, { created_at: :asc }] }
      #
      # Sort.parse(sort: '-name,+created_at,id')
      # => { sort: [{ name: :desc }, { created_at: :asc }, { id: :asc }] }
      #
      # Sort.parse(sort: ['-name', '+created_at', 'id'])
      # => { sort: [{ name: :desc }, { created_at: :asc }, { id: :asc }] }
      # ```
      def parse(options)
        new(options[:sort]).parse
      end
    end

    attr_reader :sort_by

    def initialize(sort_by)
      @sort_by = sort_by
    end

    def parse
      return if sort_by.blank?
      return [sort_by] if sort_by.is_a?(Hash)

      @sort_by = sort_by.split(','.freeze) if sort_by.is_a?(String)
      sort_by.map { |param| parse_param(param) }
    end

    private

    def parse_param(param)
      return param if param.is_a?(Hash)

      { field(param).to_sym => direction(param) }
    end

    def field(param)
      param.start_with?('-'.freeze) || param.start_with?('+'.freeze) ? param[1..-1] : param
    end

    def direction(param)
      param.start_with?('-'.freeze) ? :desc : :asc
    end
  end
end
