#!/bin/sh

source ~/.picture-haus-env.sh

export PORT=4444

bundle exec rails server -p $PORT -b 0.0.0.0
