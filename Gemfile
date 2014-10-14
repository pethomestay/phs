source 'https://rubygems.org'
ruby '1.9.3'
gem "strong_parameters"
gem 'oauth2'
gem 'redcarpet'
gem 'blogit'
gem 'fog', '~>1.2'
gem 'ckeditor'
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

gem 'will_paginate'
gem 'will_paginate-bootstrap'
gem 'alphabetical_paginate'
gem 'bootstrap-sass'
gem 'simple_form'
gem 'country_select' #Country select
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
gem 'mailgun_rails', git: 'git://github.com/darmou/mailgun_rails.git'
gem 'figaro', :github=>"laserlemon/figaro"
gem 'state_machine'

gem 'jwt' # For Zendesk Single Sign-on
gem 'createsend' # Campaign Monitor API Wrapper
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
  gem 'shoulda-matchers', '~> 2.6.1'
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

group :production, :staging do
  gem "rails_12factor"
  gem 'heroku-deflater'
end
