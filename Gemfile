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
gem 'geocoder', git: 'git://github.com/alexreisner/geocoder.git'
gem 'legato'
gem 'gon'

gem 'will_paginate'
gem 'will_paginate-bootstrap'
gem 'alphabetical_paginate'
gem 'bootstrap-sass'
gem 'owlcarousel-rails' # For carousel on Homestay listing page
gem 'simple_form'
gem 'awesome_nested_fields'
gem 'nested_form' # To replace awesome_nested_fields in the future
gem 'chosen-rails' #Integrates chosen checkbox stuff look into getting rid of this...

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
gem 'rest-client', '1.6.7'
gem 'nokogiri', '1.6.2.1'
gem 'sucker_punch'
gem 'mailgun_rails'
gem 'figaro', :github=> 'laserlemon/figaro'
gem 'state_machine'
gem 'braintree'

gem 'intercom-rails' # Intercom.io integration
gem 'intercom' # Intercom.io library for events
gem 'jwt' # For Zendesk Single Sign-on
gem 'createsend' # Campaign Monitor API Wrapper
gem 'smsglobal' # API support for smsglobal.com
gem 'phony_rails' # validate and normalize phone number
group :test, :development do
  gem 'capistrano'
  #gem 'ruby-debug-ide'

  gem 'pry'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'pry-debugger'
  gem 'pry-rails'

  gem 'rspec-rails', '~>3.0.0'
  gem 'shoulda-matchers', '~> 2.6.1'
  gem 'thin'

  # Support for stubbing model
  gem 'rspec-activemodel-mocks'
end

group :test do
  gem 'ffaker'
  gem 'timecop'
  gem 'factory_girl_rails'
  gem 'simplecov', :require => false
  gem 'capybara'
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
