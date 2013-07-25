require 'spec_helper'

describe Configurethis do
  describe "making a class configurable from a yml file" do
    context "when the base path is unmodified" do
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
end
