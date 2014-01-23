class MailboxesController < ApplicationController
	before_filter :authenticate_user!

	def index
		@mailboxes = current_user.guest_mailboxes | current_user.host_mailboxes
	end
end