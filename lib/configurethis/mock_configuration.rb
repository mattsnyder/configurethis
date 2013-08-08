module Configurethis
  class MockConfiguration
    attr_reader :path

    def initialize(values)
      @path = "<mocked_configuration>"
      @mock_values = values
    end

    def root=(key)
      @values = load_configuration.fetch(key)
    rescue ::IndexError
      raise "'#{key}' is not configured in #{path}"
    end

    def [](key)
      @values ||= load_configuration
      val = @values.fetch(key)
      return ValueContainer.new(val, path) if val.is_a?(Hash)
      val
    rescue ::IndexError
      raise "'#{key}' is not configured in #{path}"
    end

    def load_configuration
      @mock_values
    end


  end
end
