require 'rubygems'
require 'bundler/setup'
require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end


if ENV['AUTH_PASSWORD']
  require 'rack/ssl'
  use Rack::SSL

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'jilion' && password == ENV['AUTH_PASSWORD']
  end
end

run Sidekiq::Web
