require 'rails/generators'

module Devise
  module Omniauth
    class InstallGenerator < Rails::Generators::Base
      
      desc "Adds OmniAuth to an application using Devise"
      source_root File.expand_path("templates", __dir__)

      def dependencies

        omniauth_strategies = {
          google: :GoogleOauth2,
          facebook: :Facebook,
          linkedin: :LinkedIn,
          github: :GitHub,
          microsoft: :AzureActivedirectoryV2,
          apple: :Apple
        }
        if !omniauth_strategies.any? { |_, strategy_class| Gem.loaded_specs.has_key?("omniauth-#{strategy_class.to_s.underscore.gsub('_', '-')}") }
          say_error("Omniauth-generator: Need at least one OmniAuth strategy gem to be installed. Obvious candidates not found.")
          ask("Would you like to continue? (y/n)") do |answer|
            Kernel.exit(1) unless answer.downcase == 'y'
          end
        end
      
        gem "omniauth-rails_csrf_protection"
      end

      def database_update
        generate :migration, "AddOmniauthToUsers provider:string uid:string"
      end

      def update_application
        inject_into_class 'app/models/user.rb', 'User', File.read(find_in_source_paths('_user.rb')).indent(2)

        # Configure Omniauth strategies in `config/initializers/devise.rb`
        inject_into_file 'config/initializers/devise.rb', File.read(find_in_source_paths('_devise.rb')).indent(2), before: /^end/

        # Update Devise routes in `config/routes.rb`
        gsub_file 'config/routes.rb', 'devise_for :users', <<~RUBY.strip.indent(2)
          devise_for :users,
            controllers: {
              omniauth_callbacks: "users/omniauth_callbacks"
            }
        RUBY
        
        # Create `Users::OmniauthCallbacksController` to handle callbacks
        copy_file 'omniauth_callbacks_controller.rb', 'app/controllers/users/omniauth_callbacks_controller.rb'
      end

      def update_views
        gsub_file 'app/views/devise/shared/_links.html.erb', /<%- if devise_mapping\.omniauthable\?.*?\n<% end %>/m, ''

        Dir.glob("app/views/devise/{registrations,sessions}/new.html.erb").each { |f| 
          inject_into_file f, '<%= render "devise/shared/social_buttons" %>' + "\n\n", before: '<%= render "devise/shared/links" %>' 
        }

        copy_file '_social_buttons.html.erb', 'app/views/devise/shared/_social_buttons.html.erb'
      end
    end
  end
end

        




