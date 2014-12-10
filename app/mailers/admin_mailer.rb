class AdminMailer < ActionMailer::Base
  layout 'mailer'
  default to: "PetHomeStay <admin@pethomestay.com>"
  helper ApplicationHelper

  def homestay_created_admin(homestay)
    @homestay = homestay
    @user = @homestay.user
    email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    mail(from: email_with_name, subject: "A Pet Homestay Host (#{@user.first_name} #{@user.last_name}) has created a new Homestay!")
  end

  def host_rejected_paid_booking(booking)
    @booking = booking
    @user = @booking.bookee
    email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    mail(from: email_with_name, subject: "A Pet Homestay owner (#{@user.first_name} #{@user.last_name}) has declined a paid homestay booking. Booking ID: #{@booking.id}")
  end

  def braintree_payment_failure_admin(booking, result)
    @booking = booking
    @user = @booking.booker
    @transaction = result
    email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    mail(from: email_with_name, subject: "A Guest (#{@user.first_name} #{@user.last_name}) has an issue with a BRAINTREE Payment: #{transaction}")
  end
end
