class TransactionsController < ApplicationController
	before_filter :authenticate_user!

	def update
		@transaction = Transaction.find params[:id]

		stored_card_id = current_user.find_stored_card_id(params[:transaction][:select_stored_card], params[:transaction][:use_stored_card])
		if @transaction.update_status(stored_card_id)
			PetOwnerMailer.booking_receipt(@transaction.booking).deliver
			ProviderMailer.owner_confirmed(@transaction.booking).deliver
			return redirect_to booking_path(@transaction.booking, confirmed_by: 'guest')
		else
			return redirect_to new_booking_path(homestay_id: @transaction.booking.homestay.id, alert: @transaction.error_messages)
		end
	end

end