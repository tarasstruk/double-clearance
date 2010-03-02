require 'rails/generators/named_base'
require 'rails/generators/migration'

module Clearance
  module Generators
    class Base < Rails::Generators::NamedBase  #:nodoc:
      include Rails::Generators::Migration

      def self.source_root
        @_clearance_source_root ||= 
          File.expand_path("../#{generator_name}/templates", __FILE__)
      end

      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
    end
  end
end
