class ProviderMailer < ActionMailer::Base
  layout 'mailer'
  default from: "PetHomeStay <no-reply@pethomestay.com>"
  helper ApplicationHelper

  def enquiry(enquiry)
    @enquiry = enquiry
    @guest = @enquiry.user
    @pets = @guest.pets
    @host = enquiry.homestay.user
    email_with_name = "#{@host.first_name} #{@host.last_name} <#{@host.email}>"
    email = mail(to: email_with_name, subject: "#{@host.first_name.capitalize} - You have a new PetHomeStay Message!")
    email.mailgun_operations = {tag: "enquiry", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
  end

  def new_enquiry_SMS(enquiry)
    host   = enquiry.homestay.user
    host_mobile = trim(host.mobile_number)
    return unless host_mobile # abort if mobile number is illegal
    @sender = enquiry.user
    address = "#{host_mobile}@email.smsglobal.com"
    mail(to: address, subject: "New Enquiry Notification")
  end

  def owner_confirmed(booking)
    @booking = booking
    @enquiry = @booking.enquiry
		@guest = @booking.booker
    @pets = @guest.pets
    @host = @booking.bookee
    email_with_name = "#{@host.first_name} #{@host.last_name} <#{@host.email}>"
    subject =  "#{@host.first_name.capitalize} - You have a new PetHomeStay Booking!"
    email = mail(to: email_with_name, subject: subject)
    email.mailgun_operations = {tag: "owner_confirmed", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
  end

  def owner_canceled(enquiry)
    @enquiry = enquiry
    @user = @enquiry.user
    @pets = @user.pets
    @provider = enquiry.homestay.user
    email_with_name = "#{@provider.first_name} #{@provider.last_name} <#{@provider.email}>"
    mail(to: email_with_name, subject: "#{@user.first_name.capitalize} isn't going ahead with their booking!")
  end

	def booking_confirmation(booking)
		@booking = booking
		@guest = @booking.booker
		@homestay = @booking.homestay
		@host = @homestay.user
		email_with_name = "#{@host.first_name} #{@host.last_name} <#{@host.email}>"
		email = mail(to: email_with_name, subject: "You have confirmed the booking with #{@guest.first_name.capitalize}!")
    email.mailgun_operations = {tag: "booking_confirmation_for_host", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
	end

  def booking_made(booking)
    @booking = booking
    @guest = @booking.booker
    @homestay = @booking.homestay
    @host = @homestay.user
    email_with_name = "#{@host.first_name} #{@host.last_name} <#{@host.email}>"
    email = mail(to: email_with_name, subject: "Booking for #{@guest.first_name.capitalize} completed!")
    email.mailgun_operations = {tag: "booking_made_for_host", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
  end

  private
  def trim(mobile)
    mobile.gsub(/[^0-9]/, "")
    case mobile.length
    when 10 # 0416 123 456
      return '61' + mobile[1..-1]
    when 11 # 61 416 291 496
      return mobile
    when 13 # 0061 416 123 456
      return mobile[2..-1]
    else
      return nil
    end
  end
end
