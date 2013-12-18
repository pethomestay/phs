TRANSACTION_FEE = 10

BOOKING_STATUS_FINISHED = 'finished'
BOOKING_STATUS_UNFINISHED = 'unfinished'

if ['development', 'test'].include?(Rails.env)
	ENV['MERCHANT_ID']= 'EHY0047'
	ENV['TRANSACTION_PASSWORD'] = 'zggiztda'
	ENV['TRANSACTION_RESULT_URL'] = 'bookings/result?authenticity_token='
	ENV['TRANSACTION_POST_ACTION'] = 'https://api.securepay.com.au/test/directpost/authorise'
	ENV['TRANSACTION_RESPONSE_METHOD'] = 'TRUE' # GET method will be used
else
	ENV['MERCHANT_ID'] = 'EHY0047'
	ENV['TRANSACTION_PASSWORD'] = 'zggiztda'
	ENV['TRANSACTION_RESULT_URL'] = 'bookings/result?authenticity_token='
	ENV['TRANSACTION_POST_ACTION'] = 'https://api.securepay.com.au/test/directpost/authorise'
	ENV['TRANSACTION_RESPONSE_METHOD'] = 'TRUE' # false for POST method

	# live credentials
	#
	# ENV['MERCHANT_ID']              = 'EHY0047'
	# ENV['TRANSACTION_PASSWORD']     = 'wyj85zzc'
	# ENV['TRANSACTION_POST_ACTION']  = 'https://api.securepay.com.au/live/directpost/authorise'
end