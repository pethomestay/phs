class AdminMailer < ActionMailer::Base
  layout 'mailer'
  #default to: "Pet Homestay <admin@pethomestay.com>"
  default to: "Pet Homestay <dmoulder@qtome.com>" #for testing

  def homestay_created_admin(homestay)
    @user = homestay.user
    @homestay = homestay
    email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    mail(from: email_with_name, subject: "A Pet Homestay Host (#{@user.first_name} #{@user.last_name}) has created a new Homestay!")
  end
end
