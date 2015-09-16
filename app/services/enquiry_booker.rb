class EnquiryBooker
  attr_reader :enquiry, :homestay, :booking

  # Initialize EnquiryBooker
  #
  # @params
  #   enquiry [Enquiry]
  #   homestay [Homestay]
  # @api public
  # @return [EnquiryBooker]
  def initialize(enquiry, homestay=nil)
    @enquiry = enquiry
    @homestay = homestay || enquiry.homestay
    @booking = enquiry.booking || enquiry.build_booking
  end

  # Find or Create a booking
  #
  # @api public
  # @return [Booking]
  def book
    booking.attributes = booking_details
    booking.amount = booking.calculate_amount #should be calculated through booking after refactor
    booking.save
    booking.mailbox.update_attribute(:booking_id, booking.id)
    booking
  end

  private

  # Booking details
  #
  # @api private
  # @return [Hash]
  def booking_details
    {
      enquiry: enquiry,
      bookee: homestay.user,
      cost_per_night: homestay.cost_per_night.to_f,
      booker: enquiry.user,
      check_in_date: check_in_date,
      check_out_date: check_out_date,
      check_in_time: enquiry.check_in_time || DateTime.current,
      check_out_time: enquiry.check_out_time || DateTime.current,
      number_of_nights: number_of_nights,
      subtotal: homestay.cost_per_night.to_f * number_of_nights,
      host_accepted: nil,
      owner_accepted: nil,
      for_charity: homestay.for_charity
    }
  end

  # Helper method for check in date
  #
  # @api private
  # @return [DateTime]
  def check_in_date
    enquiry.check_in_date || DateTime.current
  end

  # Helper method for checkout date
  #
  # @api private
  # @return [DateTime]
  def check_out_date
    enquiry.check_out_date || DateTime.current
  end

  # Helper method for number of nights
  #
  # @api private
  # @return [Integer]
  def number_of_nights
    nights = (check_out_date - check_in_date).to_i
    nights <= 0 ? 1 : nights
  end

end
