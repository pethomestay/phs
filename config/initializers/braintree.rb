# if Rails.env != "production"
#   Braintree::Configuration.environment = :sandbox
#   Braintree::Configuration.merchant_id = "nfss7wx3fk4dzkrg"
#   Braintree::Configuration.public_key = "9mbnqmrx5js2dvm7"
#   Braintree::Configuration.private_key = "043a7de25e089ba5befc4e74ae91dad3"
# else
  Braintree::Configuration.environment = :production
  Braintree::Configuration.merchant_id = 'h2cb3xyy7sv7xrfp'
  Braintree::Configuration.public_key = 's5fp3jfqx7mjsmjh'
  Braintree::Configuration.private_key = '6fc78e670adc2c003215fcff674bbfdb'
# end