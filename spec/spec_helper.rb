# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
MIN_COVERAGE = 80
require 'simplecov'
SimpleCov.start 'rails' do
  # bug: changing the coverage_dir here breaks coverage recording.
  add_filter "/app/uploaders"
  at_exit do
    SimpleCov.result.format!
    if SimpleCov.result.covered_percent < MIN_COVERAGE
      $stderr.puts "Coverage is less than #{MIN_COVERAGE}%, build failed."
      exit 1
    end
  end
end

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'ffaker'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  Geocoder.configure(:lookup => :test)

  Geocoder::Lookup::Test.add_stub(
    "Melbourne, MB", [
      {
        'latitude'     => 40.7143528,
        'longitude'    => -74.0059731,
        'address'      => 'Melbourne, AU',
        'state'        => 'Melbourne',
        'state_code'   => 'MB',
        'country'      => 'Australia',
        'country_code' => 'Au'
      }
    ]
  )

  config.before(:each) do
    allow_any_instance_of(Homestay).to receive(:geocoding_address).and_return("Melbourne, MB")
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  RSpec.configure do |config|
    config.include Devise::TestHelpers, :type => :controller
    config.extend ControllerMacros, :type => :controller
  end

  config.infer_spec_type_from_file_location!
  config.raise_errors_for_deprecations!
end
