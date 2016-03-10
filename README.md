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

# Research

* http://weblog.rubyonrails.org/2013/6/25/Rails-4-0-final/
* http://stackoverflow.com/questions/8853748/capybara-and-rails-why-has-link-always-returns-false
* https://github.com/jnicklas/capybara
* https://github.com/jonleighton/poltergeist/issues/298
* https://github.com/jonleighton/poltergeist/tree/v1.3.0
* http://stackoverflow.com/questions/3810965/rspec-testing-templates-being-rendered
* https://github.com/plataformatec/devise
* http://stackoverflow.com/questions/5922287/rails-3-yield-content-for-with-some-default-value
* https://gist.github.com/NV/3751436
* https://github.com/diclophis/veejaytv/blob/master/public/javascripts/application.js
* http://blakesmith.me/2010/08/16/the-rails-returning-statement.html
* https://github.com/jviney/acts_as_taggable_on_steroids
* http://guides.rubyonrails.org/layouts_and_rendering.html
* https://github.com/mceachen/closure_tree/issues/45
* http://guides.rubyonrails.org/association_basics.html#the-has-many-association
* http://hawkins.io/2012/03/generating_urls_whenever_and_wherever_you_want/
* http://stackoverflow.com/questions/16228731/missing-host-to-link-to-please-provide-the-host-parameter-set-default-url-opt
* https://github.com/rspec/rspec-rails
* https://github.com/ricardocabral/iskdaemon/issues/40
* http://www.swig.org/Doc1.3/Modules.html
* http://www.stereoplex.com/blog/understanding-imports-and-pythonpath
* http://www.higherorderheroku.com/articles/using-vulcan-to-build-binary-dependencies-on-heroku/
* https://github.com/heroku/vulcan
* http://packages.ubuntu.com/lucid/imgseek
* http://ddollar.github.io/foreman/
* http://stackoverflow.com/questions/9611276/what-is-the-best-way-to-write-specs-for-code-that-depends-on-environment-variabl
* https://github.com/rails/turbolinks/pull/11
* http://stackoverflow.com/questions/8879114/how-to-secure-database-credentials-present-in-database-yml
* https://www.google.com/search?q=procile%20env%20variable%20expansion&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a&channel=np&source=hp#bav=on.2,or.r_cp.r_qf.&channel=np&fp=59d73b0aa5c23a17&q=procfile+env+variable+expansion&rls=org.mozilla:en-US%3Aofficial
* http://stackoverflow.com/questions/3065279/running-migration-on-server-when-deploying-with-capistrano
* http://www.ruby-doc.org/core-2.0/IO.html
* http://www.tigraine.at/2011/09/25/securely-managing-database-yml-when-deploying-with-capistrano/
* http://stackoverflow.com/questions/1217351/io-popen-how-to-wait-for-process-to-finish
* http://robmclarty.com/blog/how-to-deploy-a-rails-4-app-with-git-and-capistrano
* https://github.com/capistrano/capistrano/wiki/2.x-DSL-Action-Invocation-Sudo
* https://github.com/dcarley/rbenv-sudo
* https://github.com/yyuu/capistrano-rbenv
* http://stackoverflow.com/questions/14647745/using-sudo-bundle-exec-raises-bundle-command-not-found-error
* http://stackoverflow.com/questions/16842279/rails-4-image-directory-not-present-in-assets-anymore
* http://puma.io/
* https://github.com/capistrano/capistrano/wiki/2.x-from-the-beginning
* http://adriendp.wordpress.com/2013/02/20/expanding-environment-variables-in-the-rails-config-on-a-capistrano-deploy-for-a-passenger-app/
* https://www.google.com/search?q=capistrano%20.profile&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a&channel=np&source=hp#bav=on.2,or.r_cp.r_qf.&channel=np&fp=59d73b0aa5c23a17&q=capistrano+rbenv&rls=org.mozilla:en-US%3Aofficial
* https://groups.google.com/forum/#!topic/capistrano/SpncpBLUMmE
* https://www.google.com/search?q=capistrano+.profile&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a&channel=fflb#bav=on.2,or.r_cp.r_qf.&channel=fflb&fp=59d73b0aa5c23a17&q=capistrano+rbenv+sudo&rls=org.mozilla:en-US%3Aofficial
* https://github.com/puma/puma
* https://www.google.com/search?q=capistrano%20upstart%20restart&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a&channel=np&source=hp
* https://gist.github.com/carlo/1027117
* https://github.com/sstephenson/rbenv/issues/127
* https://gist.github.com/meskyanichi/2290928
* http://stackoverflow.com/questions/11444998/rake-assetsprecompile-aborting-cant-push-to-heroku
* http://stackoverflow.com/questions/8190966/capistrano-does-not-bundle-install-into-specified-gemset
* http://bundler.io/v1.3/deploying.html
* http://stackoverflow.com/questions/12919509/capistrano-deploy-assets-precompile-never-compiles-assets-why
* https://github.com/capistrano/capistrano/blob/master/lib/capistrano/recipes/deploy/assets.rb
* https://devcenter.heroku.com/articles/rails-asset-pipeline
* http://blog.sosedoff.com/2011/07/24/foreman-capistrano-for-rails-3-applications/
* http://brandontilley.com/2011/01/29/serving-rails-apps-with-rvm-nginx-unicorn-and-upstart.html
* http://sj26.com/2012/10/02/paas-ish-ubuntu
* http://icelab.com.au/articles/run-your-own-piece-of-heroku-with-foreman/
* http://stackoverflow.com/questions/12990842/how-to-use-foreman-to-export-to-upstart
* http://blog.daviddollar.org/2011/05/06/introducing-foreman.html
* http://stackoverflow.com/questions/16824561/how-to-handle-my-apps-tmp-folder-when-using-capistrano
* http://capitate.rubyforge.org/recipes/deploy.html
* http://stackoverflow.com/questions/2469059/cant-access-log-files-in-production
* http://stackoverflow.com/questions/9839468/capistrano-first-deploy-doenst-work-due-to-missing-development-log-file
* https://github.com/ddollar/foreman/issues/97
* http://superuser.com/questions/213416/running-upstart-jobs-as-unprivileged-users
* http://codepen.io/shshaw/full/gEiDt
* https://code.google.com/p/android/issues/detail?id=19827
* http://kdpeterson.net/blog/2011/06/font-size-in-mobile-browsers.html
* https://github.com/rails/strong_parameters/issues/70
* http://stackoverflow.com/questions/16258911/rails-4-authenticity-token
* https://github.com/plataformatec/devise/wiki/How-To:-Use-HTTP-Basic-Authentication
* http://zyphdesignco.com/blog/simple-auth-token-example-with-devise
* https://github.com/plataformatec/devise/wiki/How-To:-Simple-Token-Authentication-Example
* https://codeclimate.com/github/plataformatec/devise/Devise::Strategies::TokenAuthenticatable
* https://github.com/paulirish/infinite-scroll/issues/223
* http://unix.stackexchange.com/questions/65212/why-doesnt-this-xargs-command-work
* http://pornel.net/lossygif
* http://stackoverflow.com/questions/12041051/waiting-loading-transparent-gif-apng-animations
* http://loadingapng.com/
* http://mobile.smashingmagazine.com/2013/07/08/choosing-a-responsive-image-solution/
* http://nicolasgallagher.com/responsive-images-using-css3/
* http://24ways.org/2011/adaptive-images-for-responsive-designs/
* http://css-tricks.com/which-responsive-images-solution-should-you-use/
* http://stackoverflow.com/questions/10975268/position-fixed-header-in-html
* http://wiki.brightbox.co.uk/docs:gemv2:capistrano
* http://dev.mysql.com/doc/refman/5.1/en/option-file-options.html#option_general_defaults-file
* http://serverfault.com/questions/394651/mysql-my-cnf-ignored
* http://dev.mysql.com/doc/refman/5.1/en/option-files.html
* http://dev.mysql.com/doc/refman/5.1/en/command-line-options.html
* http://railsware.com/blog/2011/11/02/advanced-server-definitions-in-capistrano/
* http://superuser.com/questions/375464/cant-change-owner-user-or-group-of-directory-which-i-have-all-rights-on
* http://dev.mysql.com/doc/refman/5.0/en/changing-mysql-user.html
* http://dev.mysql.com/doc/refman/5.1/en/automatic-start.html
* http://dev.mysql.com/doc/refman/5.0/en/server-options.html
* http://stackoverflow.com/questions/7927854/start-mysql-server-from-command-line-on-mac-os-lion


# bärḏin.haus
https://bitbucket.org/dermotte/liresolr
https://github.com/kzwang/elasticsearch-image/issues/19
http://www.lire-project.net/
http://demo-itec.uni-klu.ac.at/liredemo/
https://github.com/jobready/flynn-elasticsearch/blob/develop/Dockerfile
https://flynn.io/

        app: bundle exec puma -p $PORT
        imgseek: $IMGSEEK
        web: $SUDO -n balance -d -f -b ::ffff:0.0.0.0 80 0.0.0.0:18080
        database: $MYSQLD --default-storage-engine=MyISAM --skip-grant-tables --skip-networking --datadir=$MYSQLD_DATA --log-error=/dev/stderr --long_query_time=1 --log-queries-not-using-indexes --slow-query-log=1 --slow_query_log_file=- --socket=/tmp/mysql.sock
