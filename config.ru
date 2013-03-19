require 'rubygems'
require 'bundler/setup'
require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { size: 1 }
end

require 'rack/status'
use Rack::Status

if ENV['COOKIE_SECRET']
  require 'rack/ssl'
  use Rack::SSL

  require 'rack/devise_cookie_auth'
  use Rack::DeviseCookieAuth,
    secret: ENV['COOKIE_SECRET'],
    resource: 'admin',
    redirect_to: 'https://admin.sublimevideo.net/login'
end

run Sidekiq::Web
