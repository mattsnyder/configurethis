require 'spec_helper'

describe Configurethis do
  describe "making a class configurable from a yml file" do
    context "when the base path is unmodified" do
      Given { Configurethis.defaults }
      Given (:klass) { ConventionalPath }
      Then  { expect(klass.configuration_path).to eql('config/conventional_path.yml') }
    end

    context "when the base configuration path has been modified" do
      Given { Configurethis.root_path = './spec/support' }

      context "and the class specifies it's own configuration filename" do
        Given (:klass) { OverridePath }
        Then  { expect(klass.configuration_path).to eql('./spec/support/configure/custom.yml') }
      end

      describe "and the class relies on cenvention over configuration for filename" do
        context "and there is no namespace" do
          Given (:klass) { ConventionalPath }
          Then  { expect(klass.configuration_path).to eql('./spec/support/conventional_path.yml') }
        end

        context "and the class is namespaced" do
          Given (:klass) { MyModule::ConventionalPath }
          Then  { expect(klass.configuration_path).to eql('./spec/support/my_module/conventional_path.yml') }
        end

      end
    end
  end

  describe "using configured values" do
    Given { Configurethis.root_path = File.join(File.dirname(__FILE__), 'support/config') }

    context "when the classes config file does not exist" do
      Given (:config) { MissingConfiguration }
      Then  { expect{ config.some_value }.to raise_error(RuntimeError, "Could not locate configuration file for MissingConfiguration at #{config.configuration_path}") }
    end

    context "when the value has not been set" do
      Given (:config) { RiakConfig }
      Then { expect{ config.storage_backend }.to raise_error(RuntimeError, "'storage_backend' is not configured in #{config.configuration_path}") }
    end

    context "when values are set" do
      Given (:config) { RiakConfig }
      Then  { expect(config.pb_port).to   eq(9002) }
      And   { expect(config.http_port).to eq(9000) }
      And   { expect(config.host).to      eql('127.0.0.1') }
    end
  end
end
