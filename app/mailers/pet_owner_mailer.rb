class PetOwnerMailer < ActionMailer::Base
  default from: "Pet Homestay <admin@pethomestay.com>"

  def contact_details(enquiry)
    @enquiry = enquiry
    @owner = @enquiry.user
    @homestay = @enquiry.homestay
    @provider = @homestay.user
    email_with_name = "#{@owner.first_name} #{@owner.last_name} <#{@owner.email}>"
    mail(to: email_with_name, subject: "Contact details for #{@provider.first_name}")
  end

  def provider_unavailable
    @enquiry = enquiry
    @owner = @enquiry.user
    @homestay = @enquiry.homestay
    @provider = @homestay.user
    email_with_name = "#{@owner.first_name} #{@owner.last_name} <#{@owner.email}>"
    mail(to: email_with_name, subject: "#{@provider.first_name} is unavailable")
  end

  def enquiry_reciept
    @enquiry = enquiry
    @owner = @enquiry.user
    @homestay = @enquiry.homestay
    @provider = @homestay.user
    email_with_name = "#{@owner.first_name} #{@owner.last_name} <#{@owner.email}>"
    mail(to: email_with_name, subject: "Contact details for #{@provider.first_name}")
  end
end
