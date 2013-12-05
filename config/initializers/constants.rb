TRANSACTION_FEE = 10
TRANSACTION_STATUS_APPROVED = 'approved'
TRANSACTION_STATUS_UNFINISHED = 'unfinished'

if ['development', 'test'].include?(Rails.env)
	ENV['MERCHANT_ID']= 'EHY0047'
	ENV['TRANSACTION_PASSWORD'] = 'zggiztda'
	ENV['TRANSACTION_RESULT_URL'] = 'bookings/transaction_result?authenticity_token='
	ENV['TRANSACTION_POST_ACTION'] = 'https://api.securepay.com.au/test/directpost/authorise'
	ENV['TRANSACTION_RESPONSE_METHOD'] = 'TRUE' # GET method will be used
else
	ENV['MERCHANT_ID'] = 'EHY0047'
	ENV['TRANSACTION_PASSWORD'] = 'zggiztda'
	ENV['TRANSACTION_RESULT_URL'] = 'bookings/transaction_result?authenticity_token='
	ENV['TRANSACTION_POST_ACTION'] = 'https://api.securepay.com.au/test/directpost/authorise'
	ENV['TRANSACTION_RESPONSE_METHOD'] = 'FALSE' # POST method will be used

	# live credentials
	#
	#
	# ENV['MERCHANT_ID']              = 'EHY0047'
	# ENV['TRANSACTION_PASSWORD']     = 'wyj85zzc'
	# ENV['TRANSACTION_POST_ACTION']  = 'https://api.securepay.com.au/live/directpost/authorise'
end