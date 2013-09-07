app: bundle exec puma -p 18080 -w 2
imgseek: $IMGSEEK
web: $SUDO -n balance -d -f -b ::ffff:0.0.0.0 80 0.0.0.0:18080
database: $MYSQLD --no-defaults --skip-grant-tables --skip-networking --datadir=/tmp/database --log-error=/dev/stderr --log-slow-queries=/dev/stdout --socket=/tmp/mysql.sock
