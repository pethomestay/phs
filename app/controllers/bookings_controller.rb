class BookingsController < ApplicationController
	before_filter :authenticate_user!, except: :transaction_result
	before_filter :enquiry_required, only: :new

	def new
		@transaction_payload = current_user.continue_or_start_new_transaction(@enquiry)
	end

	def transaction_result
		transaction_id = params['refid'].split('=')[1]

		@transaction = Transaction.find(transaction_id)
		@transaction.update_by_response params

		unless @transaction.errors.blank?
			flash[:error] = @transaction.error_messages
			return redirect_to new_booking_path(enquiry_id: @transaction.enquiry.id)
		end
	end

	private

	def enquiry_required
		if params[:enquiry_id].blank?
			flash[:error] = "You are not authorised to make this request!"
			return redirect_to my_account_path
		end
		@enquiry = Enquiry.find(params[:enquiry_id])
		if @enquiry.owner_accepted == true
			flash[:error] = "You have already accepted this host"
			return redirect_to my_account_path
		end
	end
end