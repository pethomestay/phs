class Guest::MessagesController < Guest::GuestController
  # GET /guest/messages
  def index
    @conversations = Mailbox.as_guest(current_user)
  end

  # POST /guest/conversation/mark_read
  # Params
  #   id: id of conversation (Mailbox)
  def mark_read
    conversation = Mailbox.find(params[:id])
    conversation.read_by(current_user)
    head :ok
  end
end
