app: bundle exec puma -p 18080
imgseek: $IMGSEEK
web: $SUDO -n balance -d -f -b ::ffff:0.0.0.0 80 0.0.0.0:18080
database: $MYSQLD --skip-grant-tables --skip-networking --datadir=/tmp/database --log-error=/dev/stderr
