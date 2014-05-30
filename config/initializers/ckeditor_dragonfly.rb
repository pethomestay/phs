# Load Dragonfly for Rails if it isn't loaded already.
require 'dragonfly'
require 'dragonfly/s3_data_store'

# Use a separate Dragonfly "app" for CKEditor.
app = Dragonfly.app(:ckeditor)


app.configure do
  # Store files in public/uploads/ckeditor. This is not
  # mandatory and the files don't even have to be stored under
  # public. If not storing under public then set server_root to nil.
  plugin :imagemagick

  protect_from_dos_attacks true
  secret "f95469e9e6eb7a1d3869f236a8bb37b82f8c1d8f01ccb51e104d75bb646980a0"

  # Accept asset requests on /ckeditor_assets. Again, this is not
  # mandatory. Just be sure to include :job somewhere.
  url_format "/uploads/ckeditor/:job/:basename.:format"

  if Rails.env.staging? || Rails.env.production?
    datastore :s3,
              bucket_name: ENV['S3_BUCKET'],
              access_key_id: ENV['S3_KEY'],
              secret_access_key: ENV['S3_SECRET'],
              region:  ENV['S3_REGION'],
              use_iam_profile: false
  else
    datastore :file,
              root_path:  Rails.root.join("public", "uploads", "ckeditor", Rails.env).to_s,
              server_root: Rails.root.join('public').to_s
  end
end

# Insert our Dragonfly "app" into the stack.
#Rails.application.middleware.insert_after Rack::Cache, Dragonfly::Middleware, :ckeditor
Rails.application.middleware.use Dragonfly::Middleware, :ckeditor