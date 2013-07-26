module Configurethis
  class ConfigurethisProperties
    class << self
      def root_path=(path)
        @@root_path = path
      end

      def root_path
        @@root_path ||= ''
      end

      def use_defaults
        @@root_path = nil
      end
    end
  end
end
