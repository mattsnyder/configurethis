require "configurethis/version"
require "configurethis/value_container"
require "configurethis/mock_configuration"
require "configurethis/configuration"
require "configurethis/configurethis_properties"

module Configurethis
  class << self
    def root_path=(path)
      ConfigurethisProperties.root_path = path
    end

    def use_defaults
      ConfigurethisProperties.use_defaults
    end
  end

  def configuration_path
    configuration.path
  end

  def set_root=(key)
    configuration.root = key.to_s
  end

  # Meant for testing different scenarios
  # and avoid using the real configuration
  # values in your tests/specs.
  #
  # To use, pass a hash that represents the
  # values you like so that it mirrors the yml files
  # structure.
  def test_with(values)
    @configuration = MockConfiguration.new values
  end

  def configure_this_with(path)
    @configuration_file = path
  end

  def method_missing(method, *args)
    configuration[method.to_s]
  end

  def reload_configuration
    @configuration = nil
    return self
  end

  def configuration
    @configuration ||= Configuration.new(configuration_file)
  end
  protected :configuration

  def configuration_file
    @configuration_file ||= underscore(self.to_s) + '.yml'
  end
  private :configuration_file

  # Borrowed from activesupport/lib/active_support/inflector/methods.rb
  # No need to bring in ActiveSupport for just this.
  def underscore(camel_cased_word)
    word = camel_cased_word.to_s.dup
    word.gsub!('::', '/')
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end
  private :underscore
end
