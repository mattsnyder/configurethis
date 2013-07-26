module Configurethis
  class Configuration
    attr_reader :path

    def initialize(configuration_file)
      @path = File.join(ConfigurethisProperties.root_path, configuration_file)
    end

    def root=(key)
      @values = load_configuration.fetch(key)
    rescue KeyError
      raise "'#{key}' is not configured in #{path}"
    end

    def [](key)
      @values ||= load_configuration
      val = @values.fetch(key)
      return ValueContainer.new(val, path) if val.is_a?(Hash)
      val
    rescue KeyError
      raise "'#{key}' is not configured in #{path}"
    end

    def load_configuration
      File.open(path){ |f| YAML::load(f) }
    rescue Exception => caught
      raise "Could not locate configuration file: #{path}"
    end


  end
end
