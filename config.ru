require 'rubygems'
require 'bundler/setup'
require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

if ENV['COOKIE_SECRET']
  require 'rack/ssl'
  use Rack::SSL

  require 'rack/cookie_auth'
  use Rack::CookieAuth,
    cookie_secret: ENV['COOKIE_SECRET'],
    cookie_name: 'remember_admin_token'
    redirect_to: 'https://admin.sublimevideo.net',
    return_to_param_key: 'admin_return_to'
end

run Sidekiq::Web
