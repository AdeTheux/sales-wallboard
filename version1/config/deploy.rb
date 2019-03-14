load "deploy/assets"
require "bundler/capistrano"
require "yaml"


set :application, "emea-sentry"
set :repository,  "git@github.com:maximeprades/emea-sentry.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "emea-prod"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
role :db,  "emea-prod", :primary => true # This is where Rails migrations will run


set :user, "emea"
set :branch, "master"

set :git_enable_submodules, 1

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :deploy_to, "/home/emea/emea-sentry"

default_environment["RAILS_ENV"] = 'production'


namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export, :roles => :web do
    run "mkdir -p /tmp/init"
    run "cd #{release_path} && bundle exec foreman export upstart /tmp/init -a #{application} -u #{user} -l #{shared_path}/log"
    sudo "mv /tmp/init/* /etc/init/"
  end
  
  desc "Start the application services"
  task :start, :roles => :web do
    sudo "start #{application}"
  end

  desc "Stop the application services"
  task :stop, :roles => :web do
    sudo "stop #{application}"
  end

  desc "Restart the application services"
  task :restart, :roles => :web do
    sudo "stop #{application} && sleep 2 && start #{application}"
  end
end

namespace :custom do

  desc "Copy the environment file"
  task :copyenv, :roles => :web do
    run "cp /home/#{user}/env #{release_path}/.env"
  end
end

namespace :deploy do
  desc "Reload the database with seed data"
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end
end


namespace :db do
  desc "Replace the development database with a copy of the production one."
  task :dump_prod, :roles => :db do
    config = YAML::load(File.read(File.join(File.dirname(__FILE__), 'database.yml')))

    run "pg_dump --no-owner --no-acl -f /tmp/dump.sql -c #{config['production']['database']}"
    download "/tmp/dump.sql", "tmp/dump.sql"
    system "psql -d #{config['development']['database']} -f tmp/dump.sql"
  end

  desc "Dump the database on the server."
  task :dump, :roles => :db do
    config = YAML::load(File.read(File.join(File.dirname(__FILE__), 'database.yml')))

    filename = "~/backups/sql/dump_#{Time.now.to_s.gsub(' ', '_')}.sql"
    run "pg_dump --no-owner --no-acl -f #{filename} -c #{config['production']['database']}"
  end
end

before "deploy:update", "db:dump"
after "deploy:update", "custom:copyenv"
after "deploy:update", "deploy:migrate"
after "deploy:update", "foreman:export"
after "deploy:update", "foreman:restart"
