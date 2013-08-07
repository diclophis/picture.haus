# OSX Makefile

RAILS_ENV:=test

screenshots = $(patsubst spec/features/%.rb, tmp/screenshots/%.png, $(wildcard spec/features/*.rb))

open: $(screenshots) 
	open tmp/screenshots/* 

Gemfile:
	bundle install

db/schema.rb:
	RAILS_ENV=$(RAILS_ENV) bundle exec rake db:migrate

tmp/screenshots/edit_person_registration_spec.png: db/schema.rb
	RAILS_ENV=$(RAILS_ENV) bundle exec foreman run rspec

tmp/screenshots/%.png: app/**/* public/**/* spec/**/* db/migrate/* lib/* spec/* db/schema.rb
	RAILS_ENV=$(RAILS_ENV) bundle exec foreman run rspec

tmp/:
	mkdir tmp/

clean:
	(mkdir tmp || touch tmp) && rm -R tmp
	touch db/schema.rb && rm -R db/schema.rb
	touch db/test.sqlite3 && rm -R db/test.sqlite3
