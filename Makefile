# OSX Makefile

screenshots = $(patsubst %,tmp/screenshots/%, $(patsubst spec/features/%.rb, %.png, $(wildcard spec/features/*.rb)))

open: $(screenshots) 
	open tmp/screenshots/* 

tmp/screenshots/%.png: app/**/* public/**/* spec/**/* db/migrate/* lib/* spec/*
	bundle exec rspec

clean:
	rm -R tmp/screenshots
