ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'shoulda/matchers'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Includes.
  config.include Requests::JsonHelpers, type: :request

  # # customized Rspec config
  # begin
  #   config.include Devise::TestHelpers, :type => :controller
  #   config.extend ControllerMacros, :type => :controller
  #
  #   Geocoder.configure(:lookup => :test)
  #
  #   Geocoder::Lookup::Test.add_stub(
  #       'Melbourne, MB',
  #       [
  #           {
  #               :latitude => 40.7143528,
  #               :longitude => -74.0059731,
  #               :address => 'Melbourne, AU',
  #               :state => 'Melbourne',
  #               :state_code => 'MB',
  #               :country => 'Australia',
  #               :country_code => 'Au'
  #           }
  #       ]
  #   )
  #
  #   config.before(:each) do
  #     allow_any_instance_of(Homestay).to receive(:geocoding_address).and_return('Melbourne, MB')
  #   end
  # end
end

# # customized Rails config
# begin
#   require 'ffaker'
# end
