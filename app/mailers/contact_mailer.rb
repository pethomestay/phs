class ContactMailer < ActionMailer::Base
  layout 'mailer'
  default from: "PetHomeStay <no-reply@pethomestay.com>"

  def new_customer_contact(contact)
    @contact = contact
    mail(to: 'support@pethomestay.com' , subject: "Contact us from #{@contact.name}")
  end

end
