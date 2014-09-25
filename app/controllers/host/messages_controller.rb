class Host::MessagesController < Host::HostController
  # GET /host/messages
  def index
    @conversations = Mailbox.as_host(current_user)
    @unread_count  = @conversations.where(host_read: false).count
  end
end
