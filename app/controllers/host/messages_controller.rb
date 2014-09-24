class Host::MessagesController < Host::HostController
  # GET /host/messages
  def index
    @conversations = Mailbox.as_host(current_user)
  end
end
