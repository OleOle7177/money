require 'rails/generators/base'

module Money 
	class InstallGenerator < Rails::Generators::Base  
      	source_root File.expand_path('../templates', __FILE__)  
             
      	def copy_migrations  
        	copy_file "migrate/create_currency.rb", "db/migrate/"  
      	end  
        
		end
	  end
	
end  