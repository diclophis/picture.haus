# OSX Makefile

RAILS_ENV:=test

screenshots = $(patsubst %,tmp/screenshots/%, $(patsubst spec/features/%.rb, %.png, $(wildcard spec/features/*.rb)))

open: $(screenshots) 
	open tmp/screenshots/* 

tmp/screenshots/%.png: app/**/* public/**/* spec/**/* db/migrate/* lib/* spec/* db/test.sqlite3
	bundle exec rspec

db/test.sqlite3: db/schema.rb
	RAILS_ENV=$(RAILS_ENV) bundle exec rake db:migrate

clean:
	touch tmp/screenshots && rm -R tmp/screenshots
	touch db/test.sqlite3 && rm -R db/test.sqlite3
