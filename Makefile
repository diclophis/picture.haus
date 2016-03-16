# Makefile for common tasks

provision:
	sh provision.sh

test: app/**/* app/**/**/* public/**/* spec/**/* db/migrate/* lib/* spec/* db/schema.rb
	sh test.sh

dev:
	sh dev.sh
