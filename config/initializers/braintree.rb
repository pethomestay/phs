if Rails.env.production?
  Braintree::Configuration.environment = :production
  Braintree::Configuration.merchant_id = 'h2cb3xyy7sv7xrfp'
  Braintree::Configuration.public_key = 'qzn64tyg6jmxvnpx'
  Braintree::Configuration.private_key = 'e43d290912e89f58a32cda916af1100b'
else
  Braintree::Configuration.environment = :sandbox
  Braintree::Configuration.merchant_id = ENV['BRAINTREE_MERCHANT_ID']
  Braintree::Configuration.public_key = ENV['BRAINTREE_PUBLIC_KEY']
  Braintree::Configuration.private_key = ENV['BRAINTREE_PRIVATE_KEY']
end
