class Admin::BookingsController < Admin::AdminController
  include BookingsHelper
	respond_to :html

	def index
		respond_with(:admin, @bookings = Booking.with_state(:finished_host_accepted).all(:order => 'created_at DESC'))
	end

  def host_cancel
    canceled(params[:booking_id], true)
    #we want to sent to the guest to let them know their booking is canceled
    AdminCanceledBookingJob.new.async.perform(params[:booking_id])
    return redirect_to admin_transactions_path
  end

  def guest_cancel
    canceled(params[:booking_id], false)
    return redirect_to admin_transactions_path
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
