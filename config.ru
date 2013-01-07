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

  use Rack::Session::Cookie, key: 'remember_admin_token', path: '/', secure: true, secret: ENV['COOKIE_SECRET']

  class AdminCookieAuth
    def initialize(app)
      @app = app
    end

    def call(env)
      a = env["rack.session"]
      puts a
      req = Rack::Request.new(env)
      a = env["rack.session"]
      puts a
      puts req.cookies
      puts req.cookies["rack.session"]
      if 1 == 2
        @app.call(env)
      else
        [302, {'Location' => 'https://admin.sublimevideo.net'}, ['Redirected to https://admin.sublimevideo.net']]
      end
    end
  end
  use AdminCookieAuth
end

run Sidekiq::Web
