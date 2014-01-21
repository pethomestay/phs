class Message < ActiveRecord::Base
	belongs_to :mailbox
	belongs_to :user

	def to_user
		(mailbox.guest_mailbox == user) ? mailbox.host_mailbox : mailbox.guest_mailbox
	end
end