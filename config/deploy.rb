require "capistrano-rbenv"
require 'bundler/capistrano'
#require "puma/capistrano"

set :rbenv_ruby_version, "2.0.0-p247"
set :rbenv_plugins, ["rbenv-build", "rbenv-sudo"]
set :sudo, "rbenv sudo"
set :sudo_password, nil


set :application, "centerology"
set :repository,  "git@github.com:diclophis/centerology-4.0"
set :deploy_to, "/home/ubuntu/centerology"
set :use_sudo, false
default_run_options[:pty] = true
set :rails_env, "production"

server "kvtx-live.com", :app, :web, :db, :primary => true

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export, :roles => :app do
    run "cd #{current_path} && rbenv sudo bundle exec foreman export daemon /etc/init -a #{application} -u nobody -l /var/log/centerology"
    run "for f in `ls /etc/init/#{application}*.conf`; do rbenv sudo sed -i.bak 's/ --exec bundle / --exec \\/home\\/ubuntu\\/.rbenv\\/shims\\/bundle /' $f; done;"
    run "for f in `ls /etc/init/#{application}-web-*.conf`; do rbenv sudo sed -i.bak 's/ --chuid nobody / /' $f; done;"
    run "touch #{current_path}/tmp/sessions && rm -R #{current_path}/tmp/sessions && mkdir -p #{current_path}/tmp/sessions && chmod 777 #{current_path}/tmp/sessions"
    run "touch #{current_path}/tmp/sockets && rm -R #{current_path}/tmp/sockets && mkdir -p #{current_path}/tmp/sockets && chmod 777 #{current_path}/tmp/sockets"
    run "chmod 777 #{current_path}/tmp/pids"


    #run "cd #{current_path} && rbenv sudo bundle exec foreman export upstart /etc/init -a #{application} -u ubuntu -l /var/log/centerology"
    #run "for f in `ls /etc/init/#{application}*.conf`; do rbenv sudo sed -i.bak 's/ su - ubuntu -c / /' $f; done;"
  end

=begin
  desc "Start the application services"
  task :start, :roles => :app do
    sudo "start #{application}"
  end
 
  desc "Stop the application services"
  task :stop, :roles => :app do
    sudo "stop #{application}"
  end
 
  desc "Restart the application services"
  task :restart, :roles => :app do
  end
=end
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "sudo restart #{application} || sudo start #{application}"
  end
end
 
after "deploy:update", "foreman:export"
after "deploy:update", "deploy:migrate"
#after "deploy:update", "foreman:restart"

namespace :config do
  task :dot_env, :except => { :no_release => true }, :role => :app do
    run "ln -sf #{release_path}/config/production.env #{release_path}/.env"
  end
  task :production_log, :except => { :no_release => true }, :role => :app do
    run "touch #{shared_path}/log/production.log && chmod 666 #{shared_path}/log/production.log"
    run "touch #{shared_path}/log/isk-daemon.log && chmod 666 #{shared_path}/log/isk-daemon.log"
  end
  task :install_mysql_table, :role => :db do
    run "test -d /tmp/database/mysql || mysql_install_db --datadir=/tmp/database --user="
    run "sudo chown -Rv nobody:ubuntu /tmp/database"
    run "sudo chmod -v g+rwx /tmp/database"
  end
end

after "deploy:finalize_update", "config:dot_env" 
after "deploy:finalize_update", "deploy:symlink_shared"
after "deploy:setup", "config:production_log" 
after "deploy:setup", "config:install_mysql_table" 

namespace :deploy do
  task :symlink_shared do
    run "ln -sf #{shared_path}/newrelic.yml #{release_path}/config/"
    run "ln -sf #{shared_path}/database.yml #{release_path}/config/"
  end
end

