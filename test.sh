#!/bin/sh

source ~/.picture-haus-env.sh

export RAILS_ENV=test

bundle exec rake db:test:prepare
bundle exec rspec
