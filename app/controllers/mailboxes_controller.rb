class MailboxesController < ApplicationController
	before_filter :authenticate_user!

	def index
		@mailboxes = current_user.guest_mailboxes | current_user.host_mailboxes
		#@mailboxes = Mailbox.with_finished_bookings(current_user)
	end
end