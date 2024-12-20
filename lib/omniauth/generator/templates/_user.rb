
devise :omniauthable, omniauth_providers: Devise.omniauth_providers

# # If you only want to allow sign-up from Omniauth providers,
# # which provide an email address, you can uncomment the following:
# validate :oauth_email_presence, on: :create
# def oauth_email_presence
#   if provider.present? && email.blank?
#     errors.add(:email, "wasn't provided by the login provider. Please sign up using an email address.")
#   end
# end
# # Also you need to override this method from Validatable (if used)
# # so that the email presence validation is not showing as a secondary error. 
# def email_required?
#   !provider.present?
# end

def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid)
    .or(where(uid: nil, provider: nil, email: auth.info.email.downcase.strip))
    .first_or_create do |user|
      user.email = auth.info.email
      user.password ||= Devise.friendly_token[0, 20]
      
      # # Depending on the provider various infos might be available. Make sure your model has the necessary fields
      #
      # if auth.info.last_name.present? && auth.info.first_name.present?
      #  user.nickname = "#{auth.info.first_name} #{auth.info.last_name[0]}."
      # elsif auth.info.name.present?
      #  user.nickname = auth.info.name
      # end
      # user.first_name = auth.info.first_name 
      # user.last_name = auth.info.last_name   
      # user.name = auth.info.name           
      # user.image_url = auth.info.image

      # If you are using confirmable and the provider(s) you use validate emails,
      # you can call `user.skip_confirmation!` to skip the confirmation emails.
      # 
      # For example for LinkedIn OpenID Connect:
      #
      # if auth.provider == 'linkedin'
      #   if user.class.devise_modules.include?(:confirmable) 
      #     if user.email.present? && auth.extra&.raw_info&.email_verified
      #       user.skip_confirmation!
      #     end
      #   else
      #     if user.email.present? && !auth.extra&.raw_info&.email_verified
      #       # We can't rely on this email really
      #       user.email = nil
      #     end
      #   end
      # end
    end
end