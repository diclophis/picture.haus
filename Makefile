# OSX Makefile

RAILS_ENV:=test

screenshots=$(patsubst spec/features/%.rb, tmp/screenshots/%.png, $(wildcard spec/features/*.rb))

open: test
	echo $(screenshots)
	open tmp/screenshots/* 

test: app/**/* app/**/**/* public/**/* spec/**/* db/migrate/* lib/* spec/* db/schema.rb
	RAILS_ENV=$(RAILS_ENV) sh run.sh rspec

db/schema.rb: Gemfile
	RAILS_ENV=$(RAILS_ENV) sh run.sh rake db:create db:migrate db:seed

Gemfile:
	bundle install

tmp/:
	mkdir tmp/

clean:
	pgrep mysql && pkill -f mysql || true
	pgrep balance && sudo pkill -f balance || true
	pgrep ruby && pkill -f ruby || true
	pgrep python && pkill -f python || true
	touch /tmp/isk_db && rm /tmp/isk_db
	(mkdir -p tmp || touch tmp) && rm -R tmp
	touch db/schema.rb && rm -R db/schema.rb
	touch db/test.sqlite3 && rm -R db/test.sqlite3
	touch /tmp/mysql && rm -R /tmp/mysql && mkdir /tmp/mysql

live:
	git commit -a && git push origin master && bundle exec cap deploy
