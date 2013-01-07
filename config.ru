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

  require 'active_support/message_verifier'
  class AdminCookieAuth
    def initialize(app)
      @app = app
    end

    def call(env)
      req = Rack::Request.new(env)
      cookie_hash = req.cookies["rack.session"]["remember_admin_token"]
      verifier = ActiveSupport::MessageVerifier.new(ENV['COOKIE_SECRET'])
      verifier.verify(cookie_hash)
      @app.call(env)
    rescue => ex
      puts ex
      [302, {'Location' => 'https://admin.sublimevideo.net'}, ['Redirected to https://admin.sublimevideo.net']]
    end
  end
  use AdminCookieAuth
end

run Sidekiq::Web
