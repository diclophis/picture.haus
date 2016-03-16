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

    # prefer gzip content transfer
    config.middleware.use Rack::Deflater

    #TODO: better caching, CDN, faster asset download requirements
    #config.middleware.use Rack::Cache,
    #  :verbose => true,
    #  :metastore   => 'file:tmp/cache/rack/meta',
    #  :entitystore => 'file:tmp/cache/rack/body'
  end
end
