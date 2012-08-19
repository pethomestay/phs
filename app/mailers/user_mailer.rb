class UserMailer < ActionMailer::Base
  layout 'mailer'
  default from: "Pet Homestay <admin@pethomestay.com>"

  def leave_feedback(user, enquiry)
    @user = user
    @enquiry = enquiry
  end
end
