set :stages, %w(production staging)
require "bundler/capistrano"
load "deploy/assets"

set :application, "pet_homestay"
set :deploy_to, "/var/www/#{application}"
set :use_sudo, false
set :user, 'ubuntu'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :scm, :git
set :repository,  "git@github.com:tinyrobotarmy/pet_homestay.git"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1

task :repo do
  set :deploy_via, :copy
  set :copy_strategy, :export
  set :branch do
    ENV["TAG"] || 'master'
  end
end

task :local_repo do
  set :repository,  File.expand_path("../../.git", __FILE__)
end


################################### production #####################################################

task :production do
  set :stage, 'production'
  set :rails_env, 'production'
  server 'ec2-54-252-64-147.ap-southeast-2.compute.amazonaws.com', :app, :db, :web, :primary => true
  set :server_name, 'pet_homestay'
end

####################################################################################################


after "deploy:cold", "deploy:seed"
after "deploy", "deploy:cleanup"

namespace :deploy do
  # namespace :assets do
  #   task :precompile, :roles => :web, :except => { :no_release => true } do
  #     from = source.next_revision(current_revision)
  #     if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
  #       run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
  #     else
  #       logger.info "Skipping asset pre-compilation because there were no asset changes"
  #     end
  #   end
  # end

  task :restart, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end

  task :seed do
    run_rake "db:seed"
  end
end

namespace :tail do

  desc "Tail carepod log"
  task :pet_homestay do
    run "tail -f #{shared_path}/log/#{rails_env}.log"
  end

end

def run_rake(cmd, options={}, &block)
  command = "cd #{latest_release} && /usr/bin/env bundle exec rake #{cmd} RAILS_ENV=#{rails_env}"
  run(command, options, &block)
end
