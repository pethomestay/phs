module BookingsHelper
  def canceled booking_id, type
    booking = Booking.find(booking_id)
    booking.status = type
    booking.save
  end
end
