module BookingsHelper
  def canceled booking_id, type
    booking = Booking.find(booking_id)
    booking.status = type
    booking.save
  end

  def has_uncanceled_bookings?(bookings)
    bookings.each {| booking|
      return true unless  is_canceled_booking?(booking)
    }
    return false
  end

  def is_canceled_booking?(booking)
    if (Booking.canceled_states.include?(booking.status))
      return true
    end
    return false
  end

  def booking_status_for_listing(booking)

    if (is_canceled_booking?(booking)) then
      if booking.status == HOST_HAS_REQUESTED_CANCELLATION
        return 'Host requested cancellation'
      elsif booking.status == BOOKING_STATUS_HOST_CANCELED
          return 'Host cancelled'
      else
          return 'Guest cancelled'
      end
    elsif (booking.host_accepted)
      return  'Confirmed'
    else
      return 'Unconfirmed'
    end
  end

  def save_guest_canceled booking_id
    @booking = Booking.find(booking_id)
    @booking.status = BOOKING_STATUS_GUEST_CANCELED

    @booking.cancel_date = Date.today #save current cancel date
    @booking.refund = @booking.calculate_refund
    if @booking.refund == 0
      @booking.refunded = true #no refund needed if amount is 0
    end
    @booking.save
    GuestCanceledBookingJob.new.async.perform(booking_id)
    @booking
  end

end
