#!/bin/sh

source ~/.bardin-haus-photography-ec2-credentials.sh

export PORT=4444

bundle exec rails server -p $PORT -b 0.0.0.0
