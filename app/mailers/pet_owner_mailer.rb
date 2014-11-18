class PetOwnerMailer < ActionMailer::Base
  layout 'mailer'
  default from: "PetHomeStay <no-reply@pethomestay.com>"
  helper ApplicationHelper

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
    email = mail(to: email_with_name, subject: "#{@host.first_name} has confirmed the booking!")
    # email.mailgun_operations = {tag: "booking_confirmation_for_guest", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
  end

  def provider_unavailable(enquiry)
    @enquiry = enquiry
    @owner = @enquiry.user
    @homestay = @enquiry.homestay
    @provider = @homestay.user
    email_with_name = "#{@owner.first_name} #{@owner.last_name} <#{@owner.email}>"
    email = mail(to: email_with_name, subject: "#{@provider.first_name} is unavailable")
    # email.mailgun_operations = {tag: "provider_unavailable", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
  end

  def host_enquiry_response(enquiry)
    @enquiry = enquiry
    @guest = @enquiry.user
    @homestay = @enquiry.homestay
    @host = @homestay.user
    email_with_name = "#{@guest.first_name} #{@guest.last_name} <#{@guest.email}>"
    email = mail(to: email_with_name, subject: "#{@host.first_name.capitalize} has sent you a message!")
    # email.mailgun_operations = {tag: "host_enquiry_response", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
  end

  def provider_not_available(booking)
    @booking = booking
    @guest = booking.booker
    @homestay = booking.homestay
    @host = booking.bookee
    email_with_name = "#{@guest.first_name} #{@guest.last_name} <#{@guest.email}>"
    subject = "#{@guest.first_name.capitalize} - You have a new PetHomeStay Message!"
    email = mail(to: email_with_name, subject: subject)
    # email.mailgun_operations = {tag: "provider_not_available", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
  end

  def provider_has_question(booking, message)
    @booking = booking
    @guest = booking.booker
    @homestay = booking.homestay
    @host = booking.bookee
    @message = message
    email_with_name = "#{@guest.first_name} #{@guest.last_name} <#{@guest.email}>"
    subject = "#{@guest.first_name.capitalize} - You have a new PetHomeStay Message!"
    email = mail(to: email_with_name, subject: subject)
    # email.mailgun_operations = {tag: "provider_has_question", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
  end

  def booking_receipt(booking)
    @booking = booking
    @guest = @booking.booker
    @homestay = @booking.homestay
    @host = @homestay.user
    email_with_name = "#{@guest.first_name} #{@guest.last_name} <#{@guest.email}>"
    email = mail(to: email_with_name, subject: "Booking has been made and a response is pending")
    # email.mailgun_operations = {tag: "booking_receipt", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
  end
end
