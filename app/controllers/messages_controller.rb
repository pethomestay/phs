class MessagesController < ApplicationController
	before_filter :authenticate_user!

	def index
		@mailbox = Mailbox.find(params[:mailbox_id])
		@messages = @mailbox.messages
	end

	def create
		@mailbox = Mailbox.find(params[:mailbox_id])
		if @mailbox.messages.create! params[:message]
			redirect_to mailbox_messages_path(@mailbox)
		end
	end


end