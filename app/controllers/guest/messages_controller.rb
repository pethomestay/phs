class Guest::MessagesController < Guest::GuestController
  # GET /guest/messages
  def index
    @conversations = Mailbox.as_guest(current_user)
  end
end
