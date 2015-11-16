# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add fonts dir to asset pipeline.
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')

# Precompile additional assets (application.js,
# application.css, and all non-JS/CSS are already added)
Rails.application.config.assets.precompile += %w( address_autocomplete.js datepicker.js new_application.css new_application.js )
