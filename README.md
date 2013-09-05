# About

Image bookmarking site

# Map

Libraries
  HasManyFriends
  ActsAsTaggableOnSteriods

Controllers
  Application
    current_page
    current_per_page

  Welcome
    index
    feed

Models
  Person
    has username
    has email
    has password
    has found many images 

  Image
    has title
    has src

  Finding
    has person
    has image

  Similarity
    has image
    has similar_image
    has rating

# Ruby version

        ruby 2.0.0p247 (2013-06-27 revision 41674) [x86_64-darwin12.4.0]

# System dependencies

        Gemfile

        git clone git@github.com:ricardocabral/iskdaemon.git
        CFLAGS=-I/usr/local/Cellar/imagemagick/6.8.0-10/include/ImageMagick python setup.py build
        PYTHONPATH=build/lib.macosx-10.8-intel-2.7 ./iskdaemon.py 
        bundle exec rake imageseek:create_similarities


# Configuration

        config/

# Database creation, Database initialization

        bundle exec rake -T | grep db
        mysql_install_db --datadir=/tmp/database --basedir=/usr/local/Cellar/mysql/5.6.10

# How to run the test suite

        make

# Services (job queues, cache servers, search engines, etc.)

# Deployment instructions
