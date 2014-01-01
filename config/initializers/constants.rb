TRANSACTION_FEE = 10


TRANSACTION_PRE_AUTHORIZATION_REQUIRED = 'Pre authorization required'
TRANSACTION_HOST_CONFIRMATION_REQUIRED = 'Host confirmation required'
TRANSACTION_FINISHED = 'transaction finished'

BOOKING_STATUS_FINISHED = 'finished'
BOOKING_STATUS_UNFINISHED = 'unfinished'

if ['development', 'test'].include?(Rails.env)
	ENV['MERCHANT_ID'] = 'EHY0047'
	ENV['TRANSACTION_PASSWORD'] = 'zggiztda'
	ENV['TRANSACTION_RESULT_URL'] = 'bookings/result?authenticity_token='
	ENV['TRANSACTION_POST_ACTION'] = 'https://api.securepay.com.au/test/directpost/authorise'
	ENV['TRANSACTION_RESPONSE_METHOD'] = 'TRUE' # GET method will be used
	ENV['TRANSACTION_XML_API'] = 'https://test.securepay.com.au/xmlapi/periodic'
else
	ENV['MERCHANT_ID'] = 'EHY0047'
	ENV['TRANSACTION_PASSWORD'] = 'zggiztda'
	ENV['TRANSACTION_RESULT_URL'] = 'bookings/result?authenticity_token='
	ENV['TRANSACTION_POST_ACTION'] = 'https://api.securepay.com.au/test/directpost/authorise'
	ENV['TRANSACTION_RESPONSE_METHOD'] = 'TRUE' # false for POST method
	ENV['TRANSACTION_XML_API'] = 'https://test.securepay.com.au/xmlapi/periodic'

	# live credentials
	#
	# ENV['MERCHANT_ID']              = 'EHY0047'
	# ENV['TRANSACTION_PASSWORD']     = 'wyj85zzc'
	# ENV['TRANSACTION_POST_ACTION']  = 'https://api.securepay.com.au/live/directpost/authorise'
	# ENV['TRANSACTION_XML_API'] = 'https://api.securepay.com.au/xmlapi/periodic'
end