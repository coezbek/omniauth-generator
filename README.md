# omniauth-generator

Rails Generator to install Omniauth for Devise

## Motivation

I needed way more time to get Devise to work with common Omniauth providers than I expected, primarily because there were no pretty buttons anywhere to use which match the 2024 design guidelines of the most important social logins.

This project contains helpers for the following social login buttons:

- Google
- Microsoft
- Apple
- Facebook
- LinkedIn
- GitHub

The buttons have basic styling and should look pretty when `<buttons>` are already styled. This is how they look out of the box with PicoCSS:

<img src="https://github.com/user-attachments/assets/9df431de-74cb-44c6-bc08-31437dffbaef" width="456" />

The following aspects of the branding guidelines were considered:

- Google wants Roboto font (you have to serve it yourself)
- Microsoft wants Segeo UI (you have to serve it yourself)
- Facebook prefers that you write "Continue with Facebook" or "Log in with Facebook". All others don't care or seem fine with "Sign Up" and "Sign In"
