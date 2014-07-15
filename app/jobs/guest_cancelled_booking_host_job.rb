
class GuestCancelledBookingHostJob
  include SuckerPunch::Job

  # The perform method is in charge of our code execution when enqueued.
  def perform(booking_id)
    booking = Booking.find(booking_id)
    UserMailer.guest_cancelled_booking_to_host(booking).deliver
  end

end