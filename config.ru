require 'rubygems'
require 'bundler/setup'
require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

module Rack
  class AdminCookieAuth
    def initialize(app)
      @app = app
    end

    def call(env)
      req = Rack::Request.new(env)
      puts request.env['rack.session']
      if 1 ==2
        @app.call(env)
      else
        [302, {'Location' => 'https://admin.sublimevideo.net'}, ['Redirected to https://admin.sublimevideo.net']]
      end
    end
  end
end

if ENV['SECRET_TOKEN']
  require 'rack/ssl'
  use Rack::SSL

  use Rack::Session::Cookie, key: 'sublimevideo_session', path: '/', secret: ENV['SECRET_TOKEN']
  use Rack::AdminCookieAuth
end

run Sidekiq::Web
