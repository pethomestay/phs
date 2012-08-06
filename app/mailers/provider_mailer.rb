class ProviderMailer < ActionMailer::Base
  default from: "Pet Homestay <admin@pethomestay.com>"

  def enquiry_email(enquiry)
    @enquiry = enquiry
    @user = @enquiry.user
    @pets = @user.pets
    @provider = enquiry.homestay.user
    email_with_name = "#{@provider.first_name} #{@provider.last_name} <#{@provider.email}>"
    mail(to: email_with_name, subject: "You've recieved an enquiry")
  end
end
