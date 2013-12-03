SYSTEM_FEE = 10
if Rails.env == "development"
	MERCHANT_ID = "EHY0047"
	TRANSACTION_PASSWORD = "zggiztda"
	TRANSACTION_RESULT_URL = "bookings/transaction_result?authenticity_token="
else
	MERCHANT_ID = "EHY0047"
	TRANSACTION_PASSWORD = "zggiztda"
	REDIRECT_URL = "bookings/transaction_result?authenticity_token="
	# MERCHANT_ID = "EHY0047" # live credentials
	# TRANSACTION_PASSWORD = "wyj85zzc" # live credentials
end