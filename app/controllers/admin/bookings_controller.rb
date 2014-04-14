class Admin::BookingsController < Admin::AdminController
  include BookingsHelper
	respond_to :html

	def index
		respond_with(:admin, @bookings = Booking.finished_and_host_accepted)
  end

  def host_cancel
    canceled(params[:booking_id], BOOKING_STATUS_HOST_CANCELED)
    #we want to sent to the host to let them know their booking is canceled
    AdminCanceledBookingJob.new.async.perform(params[:booking_id])
    return redirect_to admin_transactions_path
  end

	def reconciliations_file
		@bookings = Booking.finished_and_host_accepted_or_host_paid
		respond_to do |format|
			format.csv { send_data @bookings.to_csv }
		end
	end
end
