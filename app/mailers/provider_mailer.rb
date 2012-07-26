class ProviderMailer < ActionMailer::Base
  default from: "Pet Homestay <admin@pethomestay.com>"

  def enquiry_email(enquiry)
    @enquiry = enquiry
    @user = @enquiry.user
    @pets = @user.pets
    provider_user = enquiry.homestay.user
    email_with_name = "#{provider_user.first_name} #{provider_user.last_name} <#{provider_user.email}>"
    mail(to: email_with_name, subject: "You've recieved an enquiry")
  end
end
