require 'dragonfly'
app = Dragonfly[:images]

app.configure_with(:imagemagick)
app.configure_with(:rails)
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
end

app.define_macro(ActiveRecord::Base, :image_accessor)
