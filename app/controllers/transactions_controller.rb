class TransactionsController < ApplicationController
	before_filter :authenticate_user!

	def update
		@transaction = Transaction.find params[:id]

		if @transaction.update_status
			ProviderMailer.owner_confirmed(@transaction.booking).deliver
			return redirect_to booking_path(@transaction.booking)
		else
			return redirect_to new_booking_path(homestay_id: @transaction.booking.homestay.id, alert: @transaction.error_messages)
		end
	end

end