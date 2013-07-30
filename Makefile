# OSX Makefile

RAILS_ENV:=test

screenshots = $(patsubst %,tmp/screenshots/%, $(patsubst spec/features/%.rb, %.png, $(wildcard spec/features/*.rb)))

open: $(screenshots) 
	open tmp/screenshots/* 

Gemfile:
	bundle install

tmp/screenshots/%.png: app/**/* public/**/* spec/**/* db/migrate/* lib/* spec/* db/test.sqlite3 Gemfile Gemfile.lock
	bundle exec rspec

db/test.sqlite3: db/schema.rb Gemfile
	RAILS_ENV=$(RAILS_ENV) bundle exec rake db:migrate

clean:
	touch tmp/screenshots && rm -R tmp/screenshots
	touch db/test.sqlite3 && rm -R db/test.sqlite3
