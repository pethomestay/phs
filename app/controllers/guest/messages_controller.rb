class Guest::MessagesController < Guest::GuestController
  # GET /guest/messages
  # index action inherited from GuestController

  # POST /guest/conversation/mark_read
  # Params
  #   id: id of conversation (Mailbox)
  def mark_read
    # TODO: make sure current user is part of conversation
    # Minor security impact. Low priority.
    @conversation = Mailbox.find(params[:id])
    @conversation.read_by(current_user)
    render json: nil
  end

  # POST /guest/messages
  # Params
  #   message:
  #     id: id of conversation
  #     message_text: content of message
  def create
    if params[:message]
      @conversation = Mailbox.find(params[:message][:mailbox_id])
      @message = @conversation.messages.new
      @message.message_text = params[:message][:message]
      @message.user_id = current_user.id
    else
      # TODO: make sure current user is part of conversation
      # Minor security impact. Low priority.
      @conversation = Mailbox.find(params[:id])
      @message = @conversation.messages.new
      @message.message_text = params[:message_text]
      @message.user_id = current_user.id
    end
    if @message.save
      # TODO: Transform email notification into a SuckerPunch job
      UserMailer.receive_message(@conversation.messages.last).deliver
      render json: nil # Returning nothing will result in jQuery ajax error
    else
      head :internal_server_error
    end
  end
end
