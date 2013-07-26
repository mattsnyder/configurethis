module Configurethis
  class ValueContainer
    def initialize(original, config_path)
      @original_value = original
      @config_path = config_path
    end

    def method_missing(method, *args)
      val = @original_value.fetch(method.to_s)
      return ValueContainer.new(val, @config_path) if val.is_a?(Hash)
      val
    rescue KeyError => caught
      raise "Nested value '#{method.to_s}' is not configured in #{@config_path}"
    end
  end
end
