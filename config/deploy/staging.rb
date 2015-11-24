set :branch, :develop
set :rails_env, :staging
set :stage, :staging

server '159.203.248.178', user: 'deploy', roles: %w{app db web}, port: 2022

set :ssh_options, {
  auth_methods: ['publickey'],
  forward_agent: true,
  keys: ['/Users/dave/.ssh/ocean_rsa'],
  port: 2022
}
