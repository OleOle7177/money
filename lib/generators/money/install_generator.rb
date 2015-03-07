#lib/generators/gemname/install_generator.rb
require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module Money
  class InstallGenerator < Rails::Generators::Base
  	include Rails::Generators::Migration

	source_root File.expand_path("../templates", __FILE__)

    desc "Some description of my generator here"

    # Commandline options can be defined here using Thor-like options:
    #class_option :my_opt, :type => :boolean, :default => false, :desc => "My Option"

    # I can later access that option using:
    # options[:my_opt]


    #def self.source_root
    #  @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    #end

    def self.next_migration_number(path)
    	ActiveRecord::Generators::Base.next_migration_number(path)
  	end


	def copy_midrations
		migration_template "migrations/create_currency.rb", "db/migrate/create_currency.rb"
		migration_template "migrations/create_exchange_rate.rb", "db/migrate/create_exchange_rate.rb"
		migration_template "migrations/create_calculated_exchange_rate.rb", "db/migrate/create_calculated_exchange_rate.rb"
	end

	def copy_models 
		template "models/currency.rb", "app/models/currency.rb"
		template "models/exchange_rate.rb", "app/models/exchange_rate.rb"
		template "models/calculated_exchange_rate.rb", "app/models/calculated_exchange_rate.rb"
	end

	def copy_tasks 
		template "tasks/getcbrates.rake", "lib/tasks/getcbrates.rake"
	end


    # Generator Code. Remember this is just suped-up Thor so methods are executed in order
    

  end
end