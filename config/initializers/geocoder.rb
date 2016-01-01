Geocoder.configure(
  lookup: :google,
  api_key: ENV['GOOGLE_MAPS_API_KEY'],
  use_https: true,
  units: :km
)

# Geocoder.configure(
#   lookup: :bing,
#   api_key: 'AvPoJ5-fGVx4lv7m9JaDGmiX213KBlrAh373TEk_5epnjPgK79vGD1o58voxGIJw',
#   timeout: 20,
#   units: :km
# )
