
class AdminCancelledBookingJob
  include SuckerPunch::Job

  # The perform method is in charge of our code execution when enqueued.
  def perform(booking_id)
    booking = Booking.find(booking_id)
    UserMailer.admin_cancelled_booking(booking).deliver
  end

end