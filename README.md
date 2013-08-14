[![Build Status](https://travis-ci.org/mattsnyder/configurethis.png?branch=master)](https://travis-ci.org/mattsnyder/configurethis)
[![Code Climate](https://codeclimate.com/repos/5201505856b1022e8f000a78/badges/b728182dffefc2f344ab/gpa.png)](https://codeclimate.com/repos/5201505856b1022e8f000a78/feed)
# Configurethis
Clean up your configuration approach by using Configurethis. Configurethis allows you to access your config values using
method names instead of string literals to identify which config value you want to retrieve. 

## Quick example
```ruby
# lib/password_settings.rb
class PasswordSettings
  extend Configurethis
end

# some_ruby_file_in_my_app.rb
PasswordSettings.min_length        #=> 10
PasswordSettings.require_uppercase #=> true
PasswordSettings.storage.keep_last #=> 3
```
```yml
---
# config/password_settings.yml
minLength: 10
require_uppercase: true
storage:
  keep_last: 3
```

## Why?
Typical Ruby code has craziness like this all over the place:
```ruby
# config/initializers/load_config.rb
APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]

# application.rb
if APP_CONFIG['perform_authentication']
  # Do stuff
end
```
But that's just ugly. It relies on string literals, constants, and gets worse if you have multiple config values, or even nested config values for that matter.
`Configurethis` makes your life better and your code healthier by avoiding literals, constants and makes it easy to setup multiple config files.
All you need to do is define a Class to act as your configuration container object, create a matching YAML file, and then access your values
as needed using method calls to your new Class!
```ruby
# A cleaner way!
# config/initializers/configurethis.rb
Configurethis.root_path = File.join(Rails.root, "config")

# lib/password_settings.rb
class PasswordSettings
  extend Configurethis
end

# some_ruby_file_in_my_app.rb
PasswordSettings.min_length        #=> 10
PasswordSettings.require_uppercase #=> true
PasswordSettings.storage.keep_last #=> 3
```
```yml
---
# config/password_settings.yml
minLength: 10
require_uppercase: true
storage:
  keep_last: 3
```

## Get started with Configurethis!

Add this line to your application's Gemfile:

    gem 'configurethis'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install configurethis

## How to?

### Setup
To get started, specify where you want `Configurethis` to look for your .yml files at.
```ruby
Configurethis.root_path = '/etc/my_app'
```

If you are using `Configurethis` in a Rails app, create an initializer for `Configurethis` and add the following:
```ruby
# config/initializers/configurethis.rb
Configurethis.root_path = File.join(Rails.root, "config")
```

If your configuration is dependent on environment variables, you can specify it (Unfortunately at this time you need to do this once per each class that is environmentally dependent):
```ruby
MyConfigurationClass.set_root = Rails.env
```

### Creating a configuration
To turn your class into a configuration class, simply extend `Configurethis`
```ruby
class MyRiakConfiguration
  extend Configurethis
end
```
And create a `.yml` file that matches your class name. In this case our `.yml` file would be named `my_riak_configuration.yml`:
And it might contain something like this:
```yml
---
pb_port: 9002
http_port: 9000
host: 127.0.0.1
riak_control:
  cert: /opt/local/var/riak-1.2.0/riak.crt
```
Now you can access those values as methods off your configuration class.
```ruby
MyRiakConfiguration.pb_port            #=> 9002
MyRiakConfiguration.http_port          #=> 9000
MyRiakConfiguration.riak_control.cert  #=> "/opt/local/var/riak-1.2.0/riak.crt"
```

### Overriding
If you do not want your `.yml` file to follow convention, you can choose your own name.
```ruby
class IWantToBeDifferent
  extend Configurethis
  configure_this_with 'my_configuration_file.yml'
end
```

### Inspecting keys for a hash value
Sometimes you may want to iterate over the keys of a configured hash. You can do this by calling `#keys` on the hash to retrieve a list of the keys.
For example, if your YAML is represented as:
```yml
---
bourbon:
  distillery:
    woodford:
      # more data on woodford
    buffalo_trace:
      # more stuff
    makers_mark:
      # makers stuff
```
And let's assume our configuration class is called `BourbonConfig`, we could retrieve a list of distilleries using `#keys`:
```ruby
BourbonConfig.bourbon.distillery.keys #=> ["woodford", "buffalo_trace", "makers_mark"]
```

### Validation
If you are having problems and everything "looks clear", try running your YAML through a [YAML lint test](http://yamllint.com). 
Ruby has been known to be forgiving to poorly formatted YAML in some versions, but not others.

### Running the tests
Just run rspec from your prompt! The tests are also contain great examples about how to use Configurethis.

### Testing
While working with Configurethis in your specs/tests you can override the configuration
and avoid using the real configuration files to simulate behavior. This enables you to 
avoid using messing stubbing hierarchies and keep your tests clean!

Just pass a hash representing your configuration to `#test_with`.

```ruby
# my_configuration.rb
class BourbonConfig
  extend Configurethis
end

# my_behavior_spec.rb
it "should do some drinking" do
  BourbonConfiguration.test_with({"bourbons" => {"Woodford" => "awesome", "Buffalo Trace" => "ok"} })
  expect( my_behavior.drink("Woodford") ).to eql("awesome") # => true
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
