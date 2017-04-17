source 'https://rubygems.org'
ruby '1.9.3'
gem 'strong_parameters'
gem 'auto_strip_attributes', '~> 2.0'
gem 'oauth2', '~> 1.0'
gem 'redcarpet'
gem 'fog', '~>1.2'
gem 'rails', '3.2.18'
gem 'pg'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'flight-for-rails', '~> 1.2.0'
gem 'momentjs-rails'
gem 'haml-rails'
gem 'slim'
gem 'devise'
gem 'chronic'
gem 'omniauth-facebook', '4.0.0'
gem 'koala', '~> 1.8.0rc1'
gem 'gmaps4rails'
gem 'geocoder'
gem 'legato'
gem 'gon'
gem 'mandrill-api', require: 'mandrill'

gem 'will_paginate'
gem 'will_paginate-bootstrap'
gem 'alphabetical_paginate'
gem 'bootstrap-sass'
gem 'owlcarousel-rails' # For carousel on Homestay listing page
gem 'simple_form'
gem 'awesome_nested_fields'
gem 'nested_form' # To replace awesome_nested_fields in the future
gem 'chosen-rails' # Integrates chosen checkbox stuff look into getting rid of this...
gem 'omnicontacts'

gem 'cloudinary'
gem 'attachinary'
gem 'dragonfly', '~>1.0.5'
gem 'dragonfly-s3_data_store'
gem 'rack-cache'
gem 'actionmailer_inline_css'
gem 'net-scp', '1.2.1'
gem 'attr_encrypted'
gem 'rest-client'
gem 'mailgun_rails'
gem 'figaro'
gem 'state_machine'
gem 'braintree'

gem 'jwt', '~> 1.0' # For Zendesk Single Sign-on
gem 'phony_rails' # validate and normalize phone number

# Attributes.
gem 'virtus'

# Notifications.
gem 'apn_sender', require: 'apn'
gem 'gibbon'
gem 'mail_interceptor'

# Exceptions.
gem 'raygun4ruby'

# Background processing.
gem 'sidekiq', '3.1.4'
gem 'sidekiq-failures'
gem 'sinatra', require: false
gem 'sucker_punch'

# Documentation.
gem 'yard'
gem 'yard-restful'
gem 'yardstick'

# JSON.
gem 'jbuilder', '~> 2.0'
gem 'yajl-ruby'

# Use Unicorn as the app server.
gem 'unicorn'

group :development, :test do
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'json-schema'
  # gem 'pry'
  # gem 'pry-debugger'
  # gem 'pry-rails'
  # gem 'pry-remote'
  # gem 'pry-stack_explorer'
  gem 'rack-test', require: 'rack/test'
  gem 'rb-fsevent'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'thin'
end

group :development do
  gem 'bullet'
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-bundler', '~> 1.1.2', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rbenv'
  gem 'capistrano-unicorn-nginx', '3.4.0'
  gem 'terminal-notifier-guard'
end

group :test do
  gem 'database_cleaner'
  gem 'faker'
  gem 'shoulda-matchers', require: false
  gem 'shoulda-callback-matchers'
  gem 'test_after_commit'
end

group :assets do
  gem 'therubyracer', '~> 0.12.1'
  gem 'libv8', '~> 3.16.14'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'sass-rails'
  gem 'uglifier', '>= 1.0.3'
end

group :production, :staging do
  gem 'rails_12factor'
  gem 'heroku-deflater'
end
