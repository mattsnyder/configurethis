require "configurethis/version"
require "configurethis/null_object"
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

  def configure_this_with(path)
    @configuration_file = path
  end

  def configuration_path
    File.join(ConfigurethisProperties.root_path, configuration_file)
  end

  def method_missing(method, *args)
    configuration.fetch(method.to_s)
  end

  def configuration
    @configuration ||= File.open(configuration_path){ |f| YAML::load(f) }
  end
  protected :configuration

  private
  def configuration_file
    Maybe(@configuration_file) { underscore(self.to_s) + '.yml' }
  end

  # File activesupport/lib/active_support/inflector/methods.rb, line 89
  def underscore(camel_cased_word)
    word = camel_cased_word.to_s.dup
    word.gsub!('::', '/')
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end

end
