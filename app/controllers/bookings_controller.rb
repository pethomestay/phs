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

		if @transaction.errors.blank?
			ProviderMailer.owner_confirmed(@transaction.enquiry).deliver
			PetOwnerMailer.enquiry_reciept(@transaction.enquiry).deliver
		else
			return redirect_to(new_booking_path(enquiry_id: @transaction.enquiry.id), alert: @transaction.error_messages)
		end
	end

	def host_confirm
		@transaction_payload = Transaction.find(params[:id]).confirmed_by_host
	end

	private

	def enquiry_required
		return redirect_to my_account_path, alert: "You are not authorised to make this request!" if params[:enquiry_id].blank?
		@enquiry = Enquiry.find(params[:enquiry_id])
		return redirect_to my_account_path, alert: "You have already accepted this host" if @enquiry.owner_accepted == true
	end
end