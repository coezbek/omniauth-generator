# omniauth-generator

Rails Generator to install Omniauth for Devise via `rails g devise:omniauth:install`

## Motivation

I needed way more time to get Devise to work with common Omniauth providers than I expected, primarily because there were no pretty buttons anywhere to use which match the 2024 design guidelines of the most important social logins. Next, there were a lot of important little caveats not considered in various tutorials or [other generators](https://github.com/abhaynikam/boring_generators/tree/main/lib/generators/boring/oauth).

This project contains helpers for the following social login buttons:

- [Google](https://developers.google.com/identity/branding-guidelines) - [omniauth-google-oauth2](https://github.com/zquestz/omniauth-google-oauth2)
- [Microsoft](https://learn.microsoft.com/en-us/entra/identity-platform/howto-add-branding-in-apps)
- [Apple](https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple)
- Facebook
- LinkedIn
- [GitHub](https://github.com/logos) (they don't have a guideline for how to style their login button)

The buttons have basic styling and should look pretty when `<buttons>` are already styled. This is how they look out of the box with [PicoCSS](https://picocss.com/):

<img src="https://github.com/user-attachments/assets/9df431de-74cb-44c6-bc08-31437dffbaef" width="456" />

The following aspects of the branding guidelines were considered:

- Google wants Roboto font (you have to serve it yourself)
- Microsoft wants Segeo UI (you have to serve it yourself)
- Facebook prefers that you write "Continue with Facebook" or "Log in with Facebook". All others don't care or seem fine with "Sign Up" and "Sign In"

## Installation

This Gem expects that you already have:

- a working Devise setup (`rails devise:install`) without Omniauth
- a Devise resource called User
- routes set up via `devise_for :users`
- at least one oauth provider configured (API client id/secret) and callback URLs whitelisted.

```
# Install Gem into development (or globally, it is not need in production)
bundle add omniauth-generator --group development

# Install at least one omniauth gem/strategy, e.g. of the following
bundle add omniauth-google-oauth2
bundle add omniauth-facebook
bundle add omniauth-linkedin
bundle add omniauth-github
bundle add omniauth-azure-activedirectory-v2
bundle add omniauth-apple

# Run Generator (will bundle install for you)
rails devise:omniauth:install

# For any Gem which you want to use, you must set matching credentials in `rails credentials:edit` (or see below for ENV), e.g.:
google:
  client_id: YOUR_GOOGLE_CLIENT_ID
  client_secret: YOUR_GOOGLE_CLIENT_SECRET
# Add entries for facebook, linkedin, github, microsoft, apple (all lowercase)

# After the generator is done, review all changes
rails db:migrate

rails server
```

## Features

- The name and paths of all strategies are sane (e.g. using 'microsoft' rather than 'azure_auth' or 'google' rather than 'google_oauth2'). Sane names are used for flash as well.
- Proper error messages are returned and set in the flash.
- All social logos were optimized/minified using https://jakearchibald.github.io/svgomg/
- All styling and CSS is inlined in the `Helper` so this Gem should work with any js and css bundler.
- Put all the social buttons into a separate renderer and separate them from `app/views/devise/shared/_links.html.erb`

## Limitations

- The generator is able to support multiple `omniauth-xxx` gems at the same time, but users can not log into the same account from multiple providers when those providers provide the same email back. Compare this answer on SO: https://stackoverflow.com/a/22126562/278842
- The generator is using secrets from the Rails credentials file. If you prefer to use ENV you need to adjust the code in `config/initializers/devise.rb` accordingly.
