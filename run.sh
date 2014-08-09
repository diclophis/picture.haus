#!/bin/sh

sudo echo > /dev/null
echo starting foreman
RAILS_ENV=test bundle exec foreman start 2>&1 > /tmp/wtf &
RUN=$!
echo started foreman $RUN
while [ ! -S /tmp/mysql.sock ];
do
  printf . && sleep 0.1
done;
echo && echo running $@
RAILS_ENV=test bundle exec foreman run $@
echo stopping mysql
pkill mysqld
echo waiting for exit
wait $RUN
