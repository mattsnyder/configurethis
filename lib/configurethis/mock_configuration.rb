require "configurethis/configuration"

module Configurethis
  class MockConfiguration < Configuration
    def initialize(values)
      @path = "<mocked_configuration>"
      @mock_values = values
    end

    def load_configuration
      @mock_values
    end
  end
end
