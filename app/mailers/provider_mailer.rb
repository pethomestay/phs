class ProviderMailer < ActionMailer::Base
  layout 'mailer'
  default from: "Pet Homestay <admin@pethomestay.com>"
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
end
