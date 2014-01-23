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
		email_with_name = "#{@user.first_name} #{@user.last_name} <#{@user.email}>"
		mail(to: email_with_name, subject: "#{@from.first_name.capitalize} has sent you a message!")
	end
end
