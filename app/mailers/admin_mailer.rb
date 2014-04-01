class AdminMailer < ActionMailer::Base
  layout 'mailer'
  #default to: "Pet Homestay <admin@pethomestay.com>"
  default to: "Pet Homestay <dmoulder@qtome.com>" #for testing

  def homestay_created_admin(homestay_id)
    @homestay = Homestay.find(homestay_id) #so that only the id gets serialised
    @user = @homestay.user
    email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    mail(from: email_with_name, subject: "A Pet Homestay Host (#{@user.first_name} #{@user.last_name}) has created a new Homestay!")
  end
end
