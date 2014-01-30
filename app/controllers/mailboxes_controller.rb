class MailboxesController < ApplicationController
	before_filter :authenticate_user!

	def index
		@mailboxes = Mailbox.with_finished_bookings(current_user)
	end
end