# OSX Makefile

RAILS_ENV:=test

screenshots = $(patsubst spec/features/%.rb, tmp/screenshots/%.png, $(wildcard spec/features/*.rb))

open: $(screenshots) 
	open tmp/screenshots/* 

Gemfile:
	bundle install

tmp/screenshots/%.png: app/**/* public/**/* spec/**/* db/migrate/* lib/* spec/* db/schema.rb
	RAILS_ENV=$(RAILS_ENV) bundle exec foreman run rspec

db/schema.rb:
	RAILS_ENV=$(RAILS_ENV) bundle exec rake db:migrate

clean:
	touch db/schema.rb && rm -R db/schema.rb
	touch tmp/screenshots && rm -R tmp/screenshots
	touch db/test.sqlite3 && rm -R db/test.sqlite3
