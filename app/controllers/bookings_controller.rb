class BookingsController < ApplicationController
	before_filter :authenticate_user!, except: :transaction_result
	before_filter :enquiry_required, only: :new

	def new
		enquiry = Enquiry.find(params[:enquiry_id])
		enquiry.homestay.cost_per_night
		required_params = { no_of_nights: 1, rate_per_night: enquiry.homestay.cost_per_night,
		                    check_in_date: enquiry.check_in_date, check_out_date: enquiry.check_out_date }
		@transaction_payload = current_user.continue_or_start_new_transaction(required_params)
	end

	def transaction_result
		transaction_id = params['refid'].split('=')[1]

		@transaction = Transaction.find(transaction_id)
		@transaction.update_by_response params

		unless @transaction.errors.blank?
			flash[:error] = @transaction.error_messages
			return redirect_to new_booking_path
		end
	end

	private

	def enquiry_required
		if params[:enquiry_id].blank?
			flash[:error] = "You are not authorised to make this request!"
			return redirect_to my_account_path
		end
	end
end