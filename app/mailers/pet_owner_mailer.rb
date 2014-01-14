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

  def provider_available(enquiry)
	  @enquiry = enquiry
	  @owner = @enquiry.user
	  @homestay = @enquiry.homestay
	  @provider = @homestay.user
	  email_with_name = "#{@owner.first_name} #{@owner.last_name} <#{@owner.email}>"
	  mail(to: email_with_name, subject: "#{@provider.first_name} is available")
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
	  mail(to: email_with_name, subject: "#{@host.first_name.capitalize} has sent you a message")
  end

  def provider_not_available(booking)
	  @booking = booking
	  @owner = booking.booker
	  @homestay = booking.homestay
	  @provider = booking.bookee
	  email_with_name = "#{@owner.first_name} #{@owner.last_name} <#{@owner.email}>"
	  mail(to: email_with_name, subject: "#{@provider.first_name} is unavailable")
  end

  def provider_has_question(booking)
	  @booking = booking
	  @owner = booking.booker
	  @homestay = booking.homestay
	  @provider = booking.bookee
	  email_with_name = "#{@owner.first_name} #{@owner.last_name} <#{@owner.email}>"
	  mail(to: email_with_name, subject: "#{@provider.first_name} is unavailable")
  end

  def booking_receipt(booking)
    @booking = booking
    @owner = @booking.booker
    @homestay = @booking.homestay
    @provider = @homestay.user
    email_with_name = "#{@owner.first_name} #{@owner.last_name} <#{@owner.email}>"
    mail(to: email_with_name, subject: "#{@provider.first_name} has confirmed a PetHomeStay booking")
  end
end
