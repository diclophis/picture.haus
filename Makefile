# OSX Makefile

open: /tmp/file.png
	open /tmp/file.png

/tmp/file.png: app/*
	bundle exec rspec

clean:
	rm /tmp/file.png
