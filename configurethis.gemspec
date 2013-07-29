# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'configurethis/version'

Gem::Specification.new do |gem|
  gem.name          = "configurethis"
  gem.version       = Configurethis::VERSION
  gem.authors       = ["Matt Snyder"]
  gem.email         = ["snyder2112@me.com"]
  gem.description   = %q{Clean up your configuration approach by using Configurethis. Configurethis allows you to access your config values using method names instead of string literals to identify which config value you want to retrieve.}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/mattsnyder/configurethis"
  gem.licenses      = ['MIT', 'GPL-2']
  gem.add_development_dependency "rspec-given", ">= 3.0.0"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
