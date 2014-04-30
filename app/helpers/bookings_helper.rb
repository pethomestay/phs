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
    canceled_booking_statuses = [HOST_HAS_REQUESTED_CANCELLATION,BOOKING_STATUS_HOST_CANCELED,BOOKING_STATUS_GUEST_CANCELED]
    if (canceled_booking_statuses.include?(booking.status))
      return true
    end
    return false
  end

  def booking_status_for_listing(booking)

    if (is_canceled_booking?(booking)) then
      if booking.status == HOST_HAS_REQUESTED_CANCELLATION
        return 'Host requested cancellation'
      elsif booking.status == BOOKING_STATUS_HOST_CANCELED
          return 'Host canceled'
      else
          return 'Guest canceled'
      end
    elsif (booking.host_accepted)
      return  'Confirmed'
    else
      return 'Unconfirmed'
    end
  end

end
