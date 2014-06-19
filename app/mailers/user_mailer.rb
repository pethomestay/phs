class UserMailer < ActionMailer::Base
  layout 'mailer'
  default from: "Pet Homestay <admin@pethomestay.com>"

  def leave_feedback(to, subject, enquiry)
    @user = to
    @subject = subject
    @enquiry = enquiry
    email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    mail(to: email_with_name, subject: "#{@subject.first_name} would love some feedback!")
  end

	def receive_message(message)
		@from = message.user
		@user = message.to_user
		@message = message
		@reservation = message.mailbox.enquiry.blank? ? message.mailbox.booking : message.mailbox.enquiry
		email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
		email = mail(to: email_with_name, subject: "#{@from.first_name.capitalize} has sent you a message!")
    email.mailgun_operations = {tag: "receive_message", "tracking-opens"=>"yes", "tracking-clicks"=>"yes"}
  end

  def homestay_created(homestay)
    @homestay = homestay
    @user = @homestay.user
    email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    mail(to: email_with_name, subject: "Thank you for Applying to be a PetHomeStay Host!")
  end


  def homestay_approved(homestay)
    @homestay = homestay
    @user = @homestay.user
    email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    mail(to: email_with_name, subject: "Your Homestay listing has been approved!")
  end

	def error_report(situation, error)
		@situation = situation
		@error = error
		mail(to: ENV['DEVELOPER_EMAIL'], subject: 'An error has been occurred')
  end

  def admin_canceled_booking(booking)
    @booking = booking
    @homestay = booking.homestay
    @user = booking.booker

    email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    mail(to: email_with_name, subject: "Your booking has been canceled by the host")
  end


  def guest_canceled_booking_to_host(booking)
    @booking = booking
    @homestay = booking.homestay
    @user = booking.bookee
    @guest = booking.booker
    @booking_fee_refunded = booking.calculate_refund

    email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
    mail(to: email_with_name, subject: "Your booking has been canceled by the guest")
  end

  def guest_canceled_booking_to_guest(booking)
    @booking = booking
    @homestay = booking.homestay
    @user = booking.bookee
    @guest = booking.booker
    @days_left_until_booking_commences = booking.get_days_left
    @booking_fee_refunded = booking.calculate_refund

    email_with_name = "#{@guest.first_name} #{@guest.last_name} <#{@guest.email}>"
    mail(to: email_with_name, subject: "Your booking has been canceled as requested")
  end
end
