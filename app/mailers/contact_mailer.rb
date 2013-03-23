class ContactMailer < ActionMailer::Base
  layout 'mailer'
  default from: "Pet Homestay <admin@pethomestay.com>"

  def new_customer_contact(cpntact)
    @contact = contact
    mail(to: 'contacts@pethomestay.com' , subject: "Contact us from #{@contact.name}")
  end

end
