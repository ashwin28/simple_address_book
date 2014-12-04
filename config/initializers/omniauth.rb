OmniAuth.config.logger = Rails.logger
OmniAuth.config.on_failure = ApplicationController.action(:omniauth_callback_failure)

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"],
           { scope: 'email,profile,contacts' }
end