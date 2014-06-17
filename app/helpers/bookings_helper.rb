module BookingsHelper
  def canceled booking_id, is_host_cancelled
    booking = Booking.find(booking_id)
    has_canceled = false

    if is_host_cancelled
      has_canceled = booking.admin_cancel_booking
      if has_canceled
        booking.refund = booking.amount #The amount paid to guest should be the full amount if host cancels
      end
    else
      has_canceled = booking.guest_cancels_booking
      if has_canceled
        booking.refund = booking.calculate_refund
        GuestCanceledBookingJob.new.async.perform(booking_id) #Let the host know booking has been canceled
      end
    end
    if has_canceled
      booking.cancel_date = Date.today #save current cancel date
      if booking.refund == 0
       booking.refunded = true #no refund needed if amount is 0
      end
      if booking.cancel_reason.blank?
        booking.cancel_reason = "Admin cancelled"
      end
      booking.save
    end
    booking
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



end
