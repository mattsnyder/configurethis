require "configurethis/version"
require "configurethis/value_container"
require "configurethis/configurethis_properties"

module Configurethis

  class << self
    def root_path=(path)
      ConfigurethisProperties.root_path = path
    end

    def defaults
      ConfigurethisProperties.defaults
    end
  end

  def set_root=(value)
    @configuration = configuration.fetch(value.to_s)
  rescue KeyError
    raise "'#{value.to_s}' is not configured in #{configuration_path}"
  end

  def configure_this_with(path)
    @configuration_file = path
  end

  def configuration_path
    File.join(ConfigurethisProperties.root_path, configuration_file)
  end

  def method_missing(method, *args)
    val = configuration.fetch(method.to_s)
    return ValueContainer.new(val, configuration_path) if val.is_a?(Hash)
    val
  rescue KeyError
    raise "'#{method.to_s}' is not configured in #{configuration_path}"
  end

  def configuration
    @configuration ||= File.open(configuration_path){ |f| YAML::load(f) }
  rescue Exception => caught
    raise "Could not locate configuration file for #{self} at #{configuration_path}"
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
