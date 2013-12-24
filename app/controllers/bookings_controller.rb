class BookingsController < ApplicationController
	before_filter :authenticate_user!, except: :result
	before_filter :enquiry_required, only: :new

	def new
		@booking = current_user.find_or_create_booking_by(params)
		@transaction = current_user.find_or_create_transaction_by(@booking)
	end

	def create
		return render nothing: true
	end

	def update
		@booking = Booking.find(params[:id])
		if @booking.update_attributes!(params[:booking])
			@booking.confirmed_by_host
			return redirect_to my_account_path, alert: "You have confirmed the booking"
		else
			return redirect_to host_confirm_booking_path(@booking)
		end
	end

	def show
		@booking = Booking.find(params[:id])
		@booking.remove_notification
	end

	def result
		transaction_id = params['refid'].split('=')[1]
		@transaction = Transaction.find(transaction_id)
		@transaction.update_by_response(params)

		if @transaction.errors.blank?
			ProviderMailer.owner_confirmed(@transaction.booking).deliver
		else
			return redirect_to(new_booking_path(homestay_id: @transaction.booking.homestay.id), alert: @transaction.error_messages)
		end
	end

	def host_confirm
		@booking = Booking.find(params[:id])
	end

	def update_transaction
		transaction_payload = Booking.find(params[:booking_id]).update_transaction_by(params)
		return render json: transaction_payload
	end

	def update_booking
		Booking.find(params[:booking_id]).update_booking_by(params)
		render nothing: true
	end

	private

	def enquiry_required
		if params[:enquiry_id].blank? && params[:homestay_id].blank?
			return redirect_to my_account_path, alert: 'You are not authorised to make this request!'
		end
	end
end