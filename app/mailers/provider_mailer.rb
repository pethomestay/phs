class ProviderMailer < ActionMailer::Base
  layout 'mailer'
  default from: "Pet Homestay <admin@pethomestay.com>"

  def enquiry(enquiry)
    @enquiry = enquiry
    @user = @enquiry.user
    @pets = @user.pets
    @provider = enquiry.homestay.user
    email_with_name = "#{@provider.first_name} #{@provider.last_name} <#{@provider.email}>"
    mail(to: email_with_name, subject: "You've received an enquiry on PetHomeStay!")
  end

  def owner_confirmed(booking)
    @booking = booking
    @enquiry = @booking.enquiry
		@user = @booking.booker
    @pets = @user.pets
    @provider = @booking.bookee
    email_with_name = "#{@provider.first_name} #{@provider.last_name} <#{@provider.email}>"
    mail(to: email_with_name, subject: "#{@user.first_name} has confirmed their PetHomeStay booking with you!")
  end

  def owner_canceled(enquiry)
    @enquiry = enquiry
    @user = @enquiry.user
    @pets = @user.pets
    @provider = enquiry.homestay.user
    email_with_name = "#{@provider.first_name} #{@provider.last_name} <#{@provider.email}>"
    mail(to: email_with_name, subject: "#{@user.first_name} isn't going ahead with their booking")
  end
end
