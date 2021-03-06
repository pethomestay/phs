class Host::MessagesController < Host::HostController
  # GET /host/messages
  def index
    @conversations = Mailbox.as_host(current_user).paginate(page: params[:page], per_page: 10)
    render 'guest/messages/index'
  end
end
