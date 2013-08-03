# OSX Makefile

#PYTHONPATH:=/Users/jbardin/Desktop/iskdaemon/src/build/lib.macosx-10.8-intel-2.7
#IMGSEEK:=/Users/jbardin/Desktop/iskdaemon/src/iskdaemon.py
RAILS_ENV:=test
LAST_MIGRATION_HASH:=$(shell md5 -q db/schema.rb)

screenshots = $(patsubst %,tmp/screenshots/%, $(patsubst spec/features/%.rb, %.png, $(wildcard spec/features/*.rb)))

open: $(screenshots) 
	open tmp/screenshots/* 

Gemfile:
	bundle install

tmp/screenshots/%.png: app/**/* public/**/* spec/**/* db/migrate/* lib/* spec/* tmp/schema_$(LAST_MIGRATION_HASH).rb
	RAILS_ENV=$(RAILS_ENV) bundle exec rspec

tmp/schema_$(LAST_MIGRATION_HASH).rb:
	RAILS_ENV=$(RAILS_ENV) bundle exec rake db:migrate > tmp/schema_$(LAST_MIGRATION_HASH).rb

clean:
	touch tmp/schema_$(LAST_MIGRATION_HASH).rb && rm -R tmp/schema_$(LAST_MIGRATION_HASH).rb
	touch tmp/screenshots && rm -R tmp/screenshots
	touch db/test.sqlite3 && rm -R db/test.sqlite3
