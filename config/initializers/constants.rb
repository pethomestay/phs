SYSTEM_FEE = 10
if Rails.env == "development"
	ENV['MERCHANT_ID']= "EHY0047"
	ENV['TRANSACTION_PASSWORD'] = "zggiztda"
	ENV['TRANSACTION_RESULT_URL'] = "bookings/transaction_result?authenticity_token="
else
	ENV['MERCHANT_ID'] = "EHY0047"
	ENV['TRANSACTION_PASSWORD'] = "zggiztda"
	ENV['TRANSACTION_RESULT_URL'] = "bookings/transaction_result?authenticity_token="
	# ENV['MERCHANT_ID'] = "EHY0047" # live credentials
	# ENV['TRANSACTION_PASSWORD'] = "wyj85zzc" # live credentials
end