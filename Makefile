# OSX Makefile

#PYTHONPATH:=/Users/jbardin/Desktop/iskdaemon/src/build/lib.macosx-10.8-intel-2.7
#IMGSEEK:=/Users/jbardin/Desktop/iskdaemon/src/iskdaemon.py
RAILS_ENV:=test

screenshots = $(patsubst %,tmp/screenshots/%, $(patsubst spec/features/%.rb, %.png, $(wildcard spec/features/*.rb)))

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
