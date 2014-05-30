# Load Dragonfly for Rails if it isn't loaded already.
require "dragonfly/rails/images"

# Use a separate Dragonfly "app" for CKEditor.
app = Dragonfly[:ckeditor]
app.configure_with(:rails)
app.configure_with(:imagemagick)
if Rails.env.staging? || Rails.env.production?
  app.configure do |c|
    c.datastore = Dragonfly::DataStorage::S3DataStore.new(
        :bucket_name => ENV['S3_BUCKET'],
        :access_key_id => ENV['S3_KEY'],
        :secret_access_key => ENV['S3_SECRET'],
        :region => ENV['S3_REGION'],
        :url_host => ENV['S3_URL_HOST']
    )
  end
else
  app.configure do |c|
    # Store files in public/uploads/ckeditor. This is not
    # mandatory and the files don't even have to be stored under
    # public. If not storing under public then set server_root to nil.
    c.datastore.root_path = Rails.root.join("public", "uploads", "ckeditor", Rails.env).to_s
    c.datastore.server_root = Rails.root.join("public").to_s

    # Accept asset requests on /ckeditor_assets. Again, this is not
    # mandatory. Just be sure to include :job somewhere.
    c.url_format = "/uploads/ckeditor/:job/:basename.:format"
  end
end

# Define the ckeditor_file_accessor macro.
app.define_macro(ActiveRecord::Base, :ckeditor_file_accessor) if defined?(ActiveRecord::Base)
app.define_macro_on_include(Mongoid::Document, :ckeditor_file_accessor) if defined?(Mongoid::Document)


# Insert our Dragonfly "app" into the stack.
Rails.application.middleware.insert_after Rack::Cache, Dragonfly::Middleware, :ckeditor
