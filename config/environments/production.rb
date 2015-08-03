PetHomestay::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  config.action_controller.asset_host = ENV['CDN_DOMAIN']

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )
  config.assets.precompile += %w( new_application.css )
  config.assets.precompile += %w( address_autocomplete.js )
  config.assets.precompile += %w( datepicker.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Use mailgun for ActionMailer
  # ActionMailer::Base.smtp_settings = {
  #   :port           => ENV['MAILGUN_SMTP_PORT'],
  #   :address        => ENV['MAILGUN_SMTP_SERVER'],
  #   :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
  #   :password       => ENV['MAILGUN_SMTP_PASSWORD'],
  #   :domain         => 'www.pethomestay.com',
  #   :authentication => :plain,
  # }
  #config.action_mailer.delivery_method = :mailgun
  #config.action_mailer.mailgun_settings = {
    #  api_key: ENV['MAILGUN_API_KEY'],
     # domain: ENV['MAILGUN_DOMAIN']
  #}

  config.action_mailer.delivery_method = :smtp
	ActionMailer::Base.default charset: "utf-8"
	  	ActionMailer::Base.smtp_settings = {
		:address => "smtp.mandrillapp.com",
		:port => 587,
		:user_name => "tom@pethomestay.com",
		:password => ENV["MANDRILL_APIKEY"],
		:domain    => 'www.pethomestay.com.au',
		:authentication => "login",
		:enable_starttls_auto => true
    }

  # Add default mailer URL
  config.action_mailer.default_url_options = { :host => 'www.pethomestay.com.au' }
  config.action_mailer.asset_host = "https://www.pethomestay.com.au"

  # Use SSL
  # config.force_ssl = true

end
