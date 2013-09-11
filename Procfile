app: bundle exec puma -p 18080 -w 2
imgseek: $IMGSEEK
web: $SUDO -n balance -d -f -b ::ffff:0.0.0.0 80 0.0.0.0:18080
database: $MYSQLD --no-defaults --skip-grant-tables --skip-networking --datadir=$MYSQLD_DATA --log-error=/dev/stderr --long_query_time=1 --log-queries-not-using-indexes --slow-query-log=1 --slow_query_log_file=/dev/stdout --socket=/tmp/mysql.sock
