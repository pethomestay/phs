class Admin::BookingsController < Admin::AdminController
	respond_to :html

	def index
		respond_with(:admin, @bookings = Booking.with_state(:finished_host_accepted).all(:order => 'created_at DESC'))
	end

	def reconciliations_file
		@bookings = Booking.finished_and_host_accepted_or_host_paid
		respond_to do |format|
			format.csv { send_data @bookings.to_csv }
		end
  end

  def reset_booking_state
    booking = Booking.find(params[:id])
    booking.reset_booking
    booking.save!
    flash[:notice] = 'Booking has has been reset back to unfinished state'
    redirect_to admin_transactions_path
  end
end
