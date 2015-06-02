class InvitationMailer < ActionMailer::Base
  default :from => "email@email.com"
  
  def invitation_friends(invitation, user)
    @user = user
   	@message = message
    mail(to: email_with_name, subject: "#{@subject.first_name} would love some feedback!")	
   	@invitation = invitation
   	mail(:bcc => @invitation.recipients.join("; "), :subject => "#{@message}")
  end
end