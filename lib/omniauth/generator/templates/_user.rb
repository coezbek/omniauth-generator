
if Devise.omniauth_providers&.size > 0
  devise :omniauthable, omniauth_providers: Devise.omniauth_providers

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid)
      .or(where(uid: nil, provider: nil, email: auth.info.email.downcase.strip))
      .first_or_create do |user|
        user.email = auth.info.email
        user.password ||= Devise.friendly_token[0, 20]

        # if auth.info.last_name.present? && auth.info.first_name.present?
        #  user.nickname = "#{auth.info.first_name} #{auth.info.last_name[0]}."
        # elsif auth.info.name.present?
        #  user.nickname = auth.info.name
        # end

        # user.name = auth.info.name   # assuming the user model has a name
        # user.image = auth.info.image # assuming the user model has an image

        # If you are using confirmable and the provider(s) you use validate emails,
        # uncomment the line below to skip the confirmation emails.
        # user.skip_confirmation!
      end
  end
end
