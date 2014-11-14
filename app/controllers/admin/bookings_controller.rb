class Admin::BookingsController < Admin::AdminController
  include BookingsHelper
	respond_to :html

	def index
		respond_with(:admin, @bookings = Booking.all.select {|b| b.transaction.present? || b.payment.present? }.sort_by(&:created_at).reverse)
	end

  def host_cancel
    @booking = Booking.find(params[:booking_id])
    if @booking.payment.present?
      @booking.refund_payment
    else
      canceled(params[:booking_id], true)
    end
    #we want to sent to the guest to let them know their booking is canceled
    flash[:notice] = "Booking with transaction reference: #{Booking.find(params[:booking_id]).transaction.reference}, has been cancelled by host"
    AdminCancelledBookingJob.new.async.perform(params[:booking_id])
    return redirect_to admin_transactions_path
  end

  def guest_cancel
    @booking = Booking.find(params[:booking_id])
    if @booking.payment.present?
      @booking.refund_payment(true)
    else
      canceled(params[:booking_id], false)
    end
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
