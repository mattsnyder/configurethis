require 'spec_helper'

describe Configurethis do
  describe "making a class configurable from a yml file" do
    context "when the base path is unmodified" do
      Given { Configurethis.use_defaults }
      Given (:klass) { ConventionalPath.reload_configuration }
      Then  { expect(klass.configuration_path).to eql('/conventional_path.yml') }
    end

    context "when the base configuration path has been modified" do
      Given { Configurethis.root_path = '/my/custom/path' }

      context "and the class specifies it's own configuration filename" do
        Given (:klass) { OverridePath }
        Then  { expect(klass.configuration_path).to eql('/my/custom/path/configure/custom.yml') }
      end

      describe "and the class relies on convention over configuration for filename" do
        context "and there is no namespace" do
          Given (:klass) { ConventionalPath.reload_configuration }
          Then  { expect(klass.configuration_path).to eql('/my/custom/path/conventional_path.yml') }
        end

        context "and the class is namespaced" do
          Given (:klass) { MyModule::ConventionalPath }
          Then  { expect(klass.configuration_path).to eql('/my/custom/path/my_module/conventional_path.yml') }
        end
      end
    end
  end

  describe "specifying a root config value for all access" do
    Given { Configurethis.root_path = File.join(File.dirname(__FILE__), 'support/config') }

    context "when the root value exists" do
      Given (:rails_config) { RailsAppConfig }
      Given { rails_config.set_root = :development }
      Then  { expect(rails_config.assets.compile).to be_false }

      describe "and then we change the root value and access more values" do
        Given { rails_config.set_root = :production }
        Then  { expect(rails_config.assets.compile).to be_true }
      end
    end

    context "when the root value does not exist" do
      Given (:rails_config) { RailsAppConfig }
      Then  { expect{ rails_config.set_root = :qa }.to raise_error(RuntimeError, "'qa' is not configured in #{rails_config.configuration_path}") }
    end
  end

  describe "providing test values to use" do
    after(:each) { NestedConfig.reload_configuration }
    Given (:config) { NestedConfig }

    context "when no test values are passed" do
      Given { config.test_with(Hash.new) }
      Then  { expect{ config.level1 }.to raise_error(RuntimeError, "'level1' is not configured in <mocked_configuration>") }
    end

    context "when values are passed" do
      Given { config.test_with({ "level100" => "faked out!"}) }
      Then  { expect( config.level100 ).to eql( "faked out!" ) }

      context "and root value is set" do
        Given { config.test_with( {"qa" => { "alpha" => "a" }, "alpha" => "wrong one"} ) }
        Given { config.set_root = "qa" }
        Then  { expect( config.alpha ).to eql( "a" ) }
      end
    end
  end

  describe "using configured values" do
    Given { Configurethis.root_path = File.join(File.dirname(__FILE__), 'support/config') }

    describe "and inspecting configuration keys" do
      after(:each) { KeysConfig.reload_configuration }
      Given (:config) { KeysConfig }

      context "when value is a hash" do
        Then  { expect( config.beer.brewery.keys ).to match_array(["stone", "victory"]) }
      end

      context "when value is an array" do
        Then  { expect{ config.beer.brewery.stone.keys }.to raise_error(NoMethodError) }
      end

      context "when value is an unassigned value" do
        Then  { expect{ config.bourbon.distillery.woodford.keys }.to raise_error(NoMethodError) }
      end
    end

    context "when the classes config file does not exist" do
      Given (:config) { MissingConfiguration }
      Then  { expect{ config.some_value }.to raise_error(RuntimeError, "Could not locate configuration file: #{config.configuration_path}") }
    end

    context "when the value has not been set" do
      Given (:config) { RiakConfig }
      Then { expect{ config.storage_backend }.to raise_error(RuntimeError, "'storage_backend' is not configured in #{config.configuration_path}") }
    end

    context "when values are set" do
      Given (:config) { RiakConfig }
      Then  { expect(config.pb_port).to   eq(9002) }
      Then  { expect(config.http_port).to eq(9000) }
      Then  { expect(config.host).to      eql('127.0.0.1') }

      context "and nested" do
        Then { expect(config.riak_control.cert).to eql('/opt/local/var/riak-1.2.0/riak.crt') }
        Then { expect(config.production.riak_control.cert).to eql('/opt/local/var/riak-1.1.0/riak.crt') }
      end

      context "and deeply nested" do
        Given (:nested_config) { NestedConfig }
        Then { expect(nested_config.level1.level2.level3.level4).to eql("Hello World") }

        context "and the value is not set" do
          Then { expect{ nested_config.level1.level2.level7 }.to raise_error(RuntimeError, "Nested value 'level7' is not configured in #{nested_config.configuration_path}") }
        end
      end
    end
  end
end
