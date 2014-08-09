#!/bin/sh

sudo echo > /dev/null

if [ ! -z "$1" ];
then
  RAILS_ENV=test bundle exec foreman start 2>&1 > /tmp/wtf &
  RUN=$!

  echo   starting $RUN
  while [ ! -S /tmp/mysql.sock ];
  do
    sleep 0.1
  done;

  echo   running $@
  RAILS_ENV=test bundle exec foreman run $@

  echo   stopping
  sudo pkill -f balance
  pkill -f mysqld
  pkill -f puma
  pkill -f imageseek

  echo   exiting 
  wait $RUN
else
  bundle exec foreman start
fi
