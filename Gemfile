source 'https://rubygems.org'
ruby '1.9.3'
gem 'oauth2'
gem 'redcarpet'
gem 'legato'
gem 'blogit'
gem 'ckeditor'
gem 'rails', '3.2.12'
gem 'pg'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'haml-rails'
gem 'devise'
gem 'chronic'
gem 'omniauth-facebook'
gem 'koala', '~> 1.8.0rc1'
gem 'gmaps4rails'
gem 'geocoder', git: 'git://github.com/alexreisner/geocoder.git'

gem 'will_paginate'
gem 'bootstrap-sass'
gem 'simple_form'
gem 'country_select' #Country select
gem 'awesome_nested_fields'
gem 'chosen-rails' #Integrates chosen checkbox stuff look into getting rid of this...

gem 'dragonfly'
gem 'rack-cache'
gem 'fog'
gem 'actionmailer_inline_css'
gem 'newrelic_rpm'
gem 'net-scp', '1.0.4'
gem 'unicorn'
gem 'rest-client', '1.6.7'
gem 'nokogiri', '1.5.6'

group :test, :development do
  gem 'capistrano'
  #gem 'ruby-debug-ide'

  unless ENV['RM_INFO']
    gem 'pry'
    gem 'pry-remote'
    gem 'pry-stack_explorer'
    gem 'pry-debugger'
  end

  gem 'rspec-rails'
  gem 'shoulda-matchers', '~> 1.4.2'
  gem 'thin'
end

group :test do
  gem 'ffaker'
  gem 'timecop'
  gem 'factory_girl_rails'
  gem 'simplecov', :require => false
  gem 'webrat'
end

group :assets do
  gem 'therubyracer', '~> 0.12.1'
  gem 'libv8', '~> 3.16.14'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'sass-rails'
  gem 'uglifier', '>= 1.0.3'
end
