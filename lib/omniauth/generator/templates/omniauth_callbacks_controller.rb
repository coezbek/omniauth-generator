class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  Devise.omniauth_providers.each do |provider|
    define_method(provider) do
      handle_auth(provider.to_s.capitalize)
    end
  end

  def handle_auth(kind)
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: kind
      sign_in_and_redirect @user, event: :authentication
    else
      # Can join("\n") errors if your frontend can't handle multiple errors
      flash[:alert] = @user.errors.full_messages if is_navigational_format?
      redirect_to new_user_registration_url
    end
  end

  # Fix for error in OmniauthCallbacksController
  # OAuth2::Error does not have `error_reason` and `error` methods
  def failure_message
    exception = request.respond_to?(:get_header) ? request.get_header("omniauth.error") : request.env["omniauth.error"]
    error   = exception.error_reason if exception.respond_to?(:error_reason)
    error ||= exception.description  if exception.respond_to?(:description)
    return error.to_s if error # Description and Error_reason are normal text

    error ||= exception.error        if exception.respond_to?(:error)
    error ||= exception.code         if exception.respond_to?(:code)
    error ||= (request.respond_to?(:get_header) ? request.get_header("omniauth.error.type") : request.env["omniauth.error.type"]).to_s
    error.to_s.humanize if error
  end

  # Might want to override default behaviour: set flash and redirect to 
  # after_omniauth_failure_path_for(resource_name)
  def failure
    # Might want to log this/instrument/notify
    super
  end
end
