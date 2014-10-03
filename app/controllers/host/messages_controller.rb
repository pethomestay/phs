class Host::MessagesController < Host::HostController
  # GET /host/messages
  def index
    @conversations = Mailbox.as_host(current_user).paginate(page: params[:page], per_page: 10)
    @unread_count  = @conversations.where(host_read: false).count
  end
end
