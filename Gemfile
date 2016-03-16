source 'https://rubygems.org'

ruby '2.2.3'

# Devise is a flexible authentication solution for Rails based on Warden
gem 'devise'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'

# Sprockets Rails integration
gem 'sprockets-rails', :require => 'sprockets/railtie'

# will_paginate is a pagination library that integrates with Ruby on Rails, Sinatra, Merb, DataMapper and Sequel
gem 'will_paginate'

# cloud services library
gem 'fog'

# A ruby web server built for concurrency http://puma.io
gem 'puma'

# Real HTTP Caching for Ruby Web Apps http://rtomayko.github.io/rack-cache/
gem 'rack-cache'

# A rack middleware for enforcing rewrite rules.
gem 'rack-rewrite'

# New Relic RPM Ruby Agent http://www.newrelic.com
gem 'newrelic_rpm'

# The mime-types library provides a library and registry for information about MIME content type definitions.
gem 'mime-types'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
  # Rake is a Make-like program implemented in Ruby. Tasks and dependencies arespecified in standard Ruby syntax.
  # http://stackoverflow.com/questions/35893584/nomethoderror-undefined-method-last-comment-after-upgrading-to-rake-11/35893941
  gem 'rake', '< 11.0'

  # bindings for the SQLite3 embedded database
  gem 'sqlite3'
end

group :test do
  ## Poltergeist is a driver for Capybara. It allows you to run your Capybara tests on a headless WebKit browser, provided by PhantomJS.
  gem "poltergeist"

  # Database Cleaner is a set of strategies for cleaning your database in Ruby.
  gem "database_cleaner", '< 1.1.0'

  # a fixtures replacement with a straightforward definition syntax, support for multiple build strategies
  gem 'factory_girl_rails'

  # Mocking and stubbing library with JMock/SchMock syntax
  gem 'mocha'

  # a testing framework for Rails
  gem 'rspec-rails'

  ## for assigns(...) support in rspec-rails
  #gem 'rails-controller-testing'

  # A library for generating fake data such as names, addresses, and phone numbers
  gem 'faker'

  gem 'test-unit'
end

group :production do
  # interface to the PostgreSQL RDBMS.
  gem 'pg'

  # enables serving assets in production and setting your logger to standard out
  gem 'rails_12factor'
end
