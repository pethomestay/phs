class Message < ActiveRecord::Base
  include ShortMessagesHelper

  belongs_to :mailbox
  belongs_to :user

  # after_create :enquiry_response_message
  after_create :mark_mailbox_unread
  after_create :sms_guest_of_host_response, if: :first_host_response?

  # def enquiry_response_message
  #   if mailbox.booking.blank? && (mailbox.messages.size <= 2) && (user == mailbox.host_mailbox) && (mailbox.messages.first.user == mailbox.guest_mailbox)
  #     PetOwnerMailer.host_enquiry_response(mailbox.enquiry).deliver
  #   end
  # end

  def to_user
    (mailbox.guest_mailbox == user) ? mailbox.host_mailbox : mailbox.guest_mailbox
  end

  private

  def first_host_response?
    return false if self.message.include?(mailbox.host_mailbox.homestay.auto_interest_sms || mailbox.host_mailbox.homestay.default_auto_interest_sms )
    mailbox.messages.where(user_id: mailbox.host_mailbox_id).count == 1
  end

  def sms_guest_of_host_response
    return if mailbox.guest_mailbox.admin? # Don't send a response back if admin because of new SMS reply
    send_sms to: mailbox.guest_mailbox,
      text: 'A Host has responded to your PetHomeStay Enquiry! Log in via mobile to view it in your Inbox!'
  end

  def mark_mailbox_unread
    mailbox = self.mailbox
    if self.user == mailbox.guest_mailbox
      mailbox.host_read  = false
    elsif self.user == mailbox.host_mailbox
      mailbox.guest_read = false
    end
    mailbox.save
  end
end
