source 'https://rubygems.org'
ruby '1.9.3'
gem 'strong_parameters'
gem 'auto_strip_attributes', '~> 2.0'
gem 'oauth2'
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
gem 'omniauth-facebook'
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
gem 'newrelic_rpm'
gem 'raygun4ruby'
gem 'net-scp', '1.2.1'
gem 'unicorn'
gem 'attr_encrypted'
gem 'rest-client'
gem 'sucker_punch'
gem 'mailgun_rails'
gem 'figaro'
gem 'state_machine'
gem 'braintree'

gem 'intercom-rails' # Intercom.io integration
gem 'intercom' # Intercom.io library for events
gem 'analytics-ruby', '~> 2.0.0', require: 'segment/analytics' # Segment.io
gem 'jwt' # For Zendesk Single Sign-on
gem 'phony_rails' # validate and normalize phone number

# Attributes.
gem 'virtus'

# Documentation.
gem 'yard'
gem 'yard-restful'
gem 'yardstick'

# JSON.
gem 'jbuilder', '~> 2.0'
gem 'yajl-ruby'

# Readonly Datasource
gem 'active_hash', '~> 1.4.0'

group :development, :test do
  gem 'capistrano'
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
