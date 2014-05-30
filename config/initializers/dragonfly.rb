require 'dragonfly'
require 'dragonfly/s3_data_store'

# Configure
Dragonfly.app(:images).configure do
  plugin :imagemagick

  #protect_from_dos_attacks true
  #secret "31fd103b6f8ef6b912283a6a63ae4e5e42f4e6961150f8aec1d7a5f9d3b36127"

  #url_format "/media/:job/:name"

  datastore :s3,
            :bucket_name => ENV['S3_BUCKET'],
            :access_key_id => ENV['S3_KEY'],
            :secret_access_key => ENV['S3_SECRET'],
            :region => ENV['S3_REGION']
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware, :images

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
