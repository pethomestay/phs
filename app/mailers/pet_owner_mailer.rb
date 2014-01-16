class PetOwnerMailer < ActionMailer::Base
  layout 'mailer'
  default from: "Pet Homestay <admin@pethomestay.com>"

  def contact_details(enquiry)
    @enquiry = enquiry
    @owner = @enquiry.user
    @homestay = @enquiry.homestay
    @provider = @homestay.user
    email_with_name = "#{@owner.first_name} #{@owner.last_name} <#{@owner.email}>"
    mail(to: email_with_name, subject: "Contact details for #{@provider.first_name}")
  end

   def booking_confirmation(booking)
	  @booking = booking
	  @guest = @booking.booker
	  @homestay = @booking.homestay
	  @host = @booking.bookee
	  email_with_name = "#{@guest.first_name} #{@guest.last_name} <#{@guest.email}>"
	  mail(to: email_with_name, subject: "#{@host.first_name} has confirmed the booking!")
  end

  def provider_unavailable(enquiry)
    @enquiry = enquiry
    @owner = @enquiry.user
    @homestay = @enquiry.homestay
    @provider = @homestay.user
    email_with_name = "#{@owner.first_name} #{@owner.last_name} <#{@owner.email}>"
    mail(to: email_with_name, subject: "#{@provider.first_name} is unavailable")
  end

  def host_enquiry_response(enquiry)
	  @enquiry = enquiry
	  @guest = @enquiry.user
	  @homestay = @enquiry.homestay
	  @host = @homestay.user
	  email_with_name = "#{@guest.first_name} #{@guest.last_name} <#{@guest.email}>"
	  mail(to: email_with_name, subject: "#{@host.first_name.capitalize} has sent you a message!")
  end

  def provider_not_available(booking)
	  @booking = booking
	  @guest = booking.booker
	  @homestay = booking.homestay
	  @host = booking.bookee
	  email_with_name = "#{@guest.first_name} #{@guest.last_name} <#{@guest.email}>"
	  subject = "#{@guest.first_name.capitalize} - You have a new PetHomeStay Message!"
	  mail(to: email_with_name, subject: subject)
  end

  def provider_has_question(booking)
	  @booking = booking
	  @guest = booking.booker
	  @homestay = booking.homestay
	  @host = booking.bookee
	  email_with_name = "#{@guest.first_name} #{@guest.last_name} <#{@guest.email}>"
	  subject = "#{@guest.first_name.capitalize} - You have a new PetHomeStay Message!"
	  mail(to: email_with_name, subject: subject)
  end

  def booking_receipt(booking)
    @booking = booking
    @guest = @booking.booker
    @homestay = @booking.homestay
    @host = @homestay.user
    email_with_name = "#{@guest.first_name} #{@guest.last_name} <#{@guest.email}>"
    mail(to: email_with_name, subject: "You have made a booking!")
  end
end
