lock '3.4.0'

# App.
set :application, 'pethomestay'
set :unicorn_service, "unicorn_#{fetch(:application)}"
set :user, 'deploy'

# SSH.
set :pty, true
set :ssh_options, {
  config: false
}

# Repo.
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :repo_url, 'git@github.com:pethomestay/phs.git'
set :scm, :git

# Target.
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:stage)}/#{fetch(:application)}"

# Links.
set :linked_files, %w{.rbenv-vars config/database.yml config/unicorn.rb}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets public/assets vendor/bundle}

# Ruby.
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_ruby, '1.9.3-p547'
set :rbenv_type, :user

require 'appsignal/capistrano'
