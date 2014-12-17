if Rails.env.development?
  Braintree::Configuration.environment = :sandbox
  Braintree::Configuration.merchant_id = "nfss7wx3fk4dzkrg"
  Braintree::Configuration.public_key = "9mbnqmrx5js2dvm7"
  Braintree::Configuration.private_key = "043a7de25e089ba5befc4e74ae91dad3"
else
  Braintree::Configuration.environment = :production
  Braintree::Configuration.merchant_id = 'h2cb3xyy7sv7xrfp'
  Braintree::Configuration.public_key = 'qzn64tyg6jmxvnpx'
  Braintree::Configuration.private_key = 'e43d290912e89f58a32cda916af1100b'
end
