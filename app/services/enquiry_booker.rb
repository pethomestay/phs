class EnquiryBooker
  attr_reader :enquiry, :homestay, :booking

  def initialize(enquiry, homestay=nil)
    @enquiry = enquiry
    @homestay = homestay || enquiry.homestay
    @booking = enquiry.booking || enquiry.build_booking
  end

  def book
    booking.attributes = booking_details
    booking.amount = booking.calculate_amount #should be calculated through booking after refactor
    booking.save
    booking.mailbox.update_attribute(:booking_id, booking.id)
    booking
  end

  private

  def booking_details
    {
      enquiry: enquiry,
      bookee: homestay.user,
      cost_per_night: homestay.cost_per_night.to_f,
      booker: enquiry.user,
      check_in_date: check_in_date,
      check_out_date: check_out_date,
      check_in_time: enquiry.check_in_time || DateTime.now,
      check_out_time: enquiry.check_out_time || DateTime.now,
      number_of_nights: number_of_nights,
      subtotal: homestay.cost_per_night.to_f * number_of_nights,
      host_accepted: nil,
      owner_accepted: nil,
      for_charity: homestay.for_charity
    }
  end

  def check_in_date
    enquiry.check_in_date || DateTime.now
  end

  def check_out_date
    enquiry.check_out_date || DateTime.now
  end

  def number_of_nights
    nights = (check_out_date - check_in_date).to_i
    nights <= 0 ? 1 : nights
  end

end
