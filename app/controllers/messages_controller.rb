class MessagesController < ApplicationController
	before_filter :authenticate_user!

	def index
		@mailbox = Mailbox.find(params[:mailbox_id])
		@messages = @mailbox.messages.reverse
	end

	def create
		@mailbox = Mailbox.find(params[:mailbox_id])
		if @mailbox.messages.create! params[:message]
			redirect_to mailbox_messages_path(@mailbox)
			UserMailer.receive_message(@mailbox.messages.last).deliver
		end
	end

end