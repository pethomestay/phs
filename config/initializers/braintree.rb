Braintree::Configuration.environment =
  ENV['BRAINTREE_PRIVATE_KEY'] ? :production : :sandbox
Braintree::Configuration.merchant_id =
  ENV['BRAINTREE_MERCHANT_ID'] || 'nfss7wx3fk4dzkrg'
Braintree::Configuration.public_key  =
  ENV['BRAINTREE_PUBLIC_KEY']  || '9mbnqmrx5js2dvm7'
Braintree::Configuration.private_key =
  ENV['BRAINTREE_PRIVATE_KEY'] || '043a7de25e089ba5befc4e74ae91dad3'
