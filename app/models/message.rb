class Message < ActiveRecord::Base
	belongs_to :mailbox
	belongs_to :user

	after_create :enquiry_response_message

	def enquiry_response_message
		if mailbox.booking.blank? && (mailbox.messages.size <= 2) && (user == mailbox.host_mailbox) && (mailbox.messages.first.user == mailbox.guest_mailbox)
			PetOwnerMailer.host_enquiry_response(mailbox.enquiry).deliver
		end
	end

	def to_user
		(mailbox.guest_mailbox == user) ? mailbox.host_mailbox : mailbox.guest_mailbox
	end
end