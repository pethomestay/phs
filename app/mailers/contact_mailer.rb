class ContactMailer < ActionMailer::Base
  layout 'mailer'
  default from: "Pet Homestay <admin@pethomestay.com>"

  def new_customer_contact(contact)
    @contact = contact
    mail(to: 'admin@pethomestay.com' , subject: "Contact us from #{@contact.name}")
  end

end
