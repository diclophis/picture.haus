require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Centerology
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.middleware.use Rack::Deflater
    config.middleware.use Rack::Cache,
    :verbose => true,
    :metastore   => 'file:tmp/cache/rack/meta',
    :entitystore => 'file:tmp/cache/rack/body'

 # You probably only want config.assets.compile = true in development,
# and set to false in test+production. When config.assets.compile is
# true the app uses Sprockets for asset serving at runtime instead
# of the send_file rules below. This is useful in development when
# assets can change often.
#serve_precompiled_assets_only = !config.assets.compile
#break unless serve_precompiled_assets_only
config.middleware.swap(ActionDispatch::Static, Rack::Rewrite) do
local_file_path = ->(match, rack_env) {
path = rack_env['PATH_INFO']
raise 'Illegal request' if path.include?('..')
"public#{path}"
}
 
local_gz_file_path = ->(match, rack_env) {
"#{local_file_path.call(nil, rack_env)}.gz"
}
 
is_gzippable_request = ->(rack_env) {
client_accepts_gzip = !!(rack_env['HTTP_ACCEPT_ENCODING'] =~ /\bgzip\b/)
return client_accepts_gzip && File.exists?(local_gz_file_path.call(nil, rack_env))
}
 
is_static_request = ->(rack_env) {
return File.exists?(local_file_path.call(nil, rack_env))
}
seconds_in_day = 24*60*60
seconds_in_month = 31*seconds_in_day
seconds_in_year = 365*seconds_in_day
send_file %r{\A\/favicon\.ico},
local_file_path,
:headers => {
'Cache-Control' => "public, max-age=#{seconds_in_month}",
'Last-Modified' => 'Mon, 10 Jan 2005 10:00:00 GMT'
},
:if => is_static_request
 
send_file %r{\A\/robots\.txt},
local_file_path,
:headers => {
'Cache-Control' => "public, max-age=#{seconds_in_day}"
},
:if => is_static_request
 
# Gzipped css
send_file %r{\A\/assets\/.+\.css},
local_gz_file_path,
:headers => {
'Vary' => 'Accept-Encoding',
'Content-Encoding' => 'gzip',
'Content-Type' => 'text/css',
'Cache-Control' => "public, max-age=#{seconds_in_year}",
'Last-Modified' => 'Mon, 10 Jan 2005 10:00:00 GMT'
},
:if => is_gzippable_request
 
# Gzipped js
send_file %r{\A\/assets\/.+\.js},
local_gz_file_path,
:headers => {
'Vary' => 'Accept-Encoding',
'Content-Encoding' => 'gzip',
'Content-Type' => 'application/javascript',
'Cache-Control' => "public, max-age=#{seconds_in_year}",
'Last-Modified' => 'Mon, 10 Jan 2005 10:00:00 GMT'
},
:if => is_gzippable_request
 
# js+css for gzip-unsupported clients
send_file %r{\A\/assets\/.+\.(?:css|js)},
local_file_path,
:headers => {
'Vary' => 'Accept-Encoding',
'Cache-Control' => "public, max-age=#{seconds_in_year}",
'Last-Modified' => 'Mon, 10 Jan 2005 10:00:00 GMT'
},
:if => is_static_request
 
# Non-css, non-js assets
send_file %r{\A\/assets\/.+},
local_file_path,
:headers => {
'Cache-Control' => "public, max-age=#{seconds_in_year}",
'Last-Modified' => 'Mon, 10 Jan 2005 10:00:00 GMT'
},
:if => is_static_request
end

  end
end
