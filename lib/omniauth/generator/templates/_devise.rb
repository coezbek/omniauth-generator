# Add all the Omniauth strategies which are present in the credentials file
omniauth_strategies = {
  google: :GoogleOauth2,
  facebook: :Facebook,
  linkedin: :LinkedIn,
  github: :GitHub,
  microsoft: :AzureActivedirectoryV2,
  apple: :Apple
}

omniauth_strategies.each do |strategy, strategy_class|
  if Rails.application.credentials[strategy].present?
    begin
      clazz_name = "OmniAuth::Strategies::#{strategy_class}"
      clazz = Kernel.const_get(clazz_name)
    rescue NameError
      require 'active_support/inflector'
      puts "Gem for OmniAuth strategy '#{strategy}' not found. Please add to your Gemfile. Likely named 'omniauth-#{strategy_class.to_s.underscore.gsub('_', '-')}' or ...-oauth2."
      Kernel.exit(1)
    end

    config.omniauth strategy,
      client_id: Rails.application.credentials[strategy][:client_id],
      client_secret: Rails.application.credentials[strategy][:client_secret],
      strategy_class: clazz,
      name: strategy # Even though this is the same as the provider key above, otherwise routes don't match
  else
    begin
      clazz_name = "OmniAuth::Strategies::#{strategy_class}"
      clazz = Kernel.const_get(clazz_name)
      puts "Can't start without #{strategy} API credentials. Please run 'rails credentials:edit --environment xxx'."
      # Kernel.exit(1)
    rescue NameError
      # Do nothing - Credentials not found but Gem also not there
    end if Rails.env.development?
  end
end
