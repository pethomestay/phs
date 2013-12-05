class BookingsController < ApplicationController
	before_filter :authenticate_user!

	def new
		# TODO: turn required_params to actual params or actual host information
		required_params = { no_of_nights: 2, rate_per_night: 30 }
		@transaction_payload = current_user.continue_or_start_new_transaction(required_params)
	end

	def transaction_result
		transaction_id = params["refid"].split("=")[1]

		@transaction = Transaction.find(transaction_id)
		@transaction.update_by_response params

		unless @transaction.errors.blank?
			flash[:error] = @transaction.error_messages
			return redirect_to new_booking_path
		end
	end
end