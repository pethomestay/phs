class AdminMailer < ActionMailer::Base
  layout 'mailer'
  default to: "Pet Homestay <admin@pethomestay.com>"
  helper ApplicationHelper

  def homestay_created_admin(homestay)
    @homestay = homestay
    @user = @homestay.user
    email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    mail(from: email_with_name, subject: "A Pet Homestay Host (#{@user.first_name} #{@user.last_name}) has created a new Homestay!")
  end

  def payment_failure_admin(booking,transaction)
    @booking = booking
    @user = @booking.booker
    @transaction = transaction
    email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    mail(from: email_with_name, subject: "A Pet Homestay Guest (#{@user.first_name} #{@user.last_name}) has an issue with a booking payment Transaction Id #{@transaction.id.to_s}")
  end
end
