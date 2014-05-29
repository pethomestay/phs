require 'dragonfly'
require 'dragonfly/s3_data_store'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  protect_from_dos_attacks true
  secret "f95469e9e6eb7a1d3869f236a8bb37b82f8c1d8f01ccb51e104d75bb646980a0"

  url_format "/media/:job/:name"

  if Rails.env.staging? || Rails.env.production?
    datastore :s3,
            bucket_name: ENV['S3_BUCKET'],
            access_key_id: ENV['S3_KEY'],
            secret_access_key: ENV['S3_SECRET']
    else
      datastore :file,
                root_path: Rails.root.join('public/system/dragonfly', Rails.env),
                server_root: Rails.root.join('public')
  end

end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
