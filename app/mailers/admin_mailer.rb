class AdminMailer < ActionMailer::Base
  layout 'mailer'
  default to: "Pet Homestay <admin@pethomestay.com>"

  def homestay_created_admin(homestay)
    @homestay = homestay
    @user = @homestay.user
    email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    mail(from: email_with_name, subject: "A Pet Homestay Host (#{@user.first_name} #{@user.last_name}) has created a new Homestay!")
  end
end
