
class AdminCanceledBookingJob
  include SuckerPunch::Job

  # The perform method is in charge of our code execution when enqueued.
  def perform(booking_id)
    p "I got to purform"
    booking = Booking.find(booking_id)
    UserMailer.admin_canceled_booking(booking).deliver
  end

end