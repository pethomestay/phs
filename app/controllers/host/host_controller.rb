class Host::HostController < ApplicationController
  layout 'new_application'

  before_filter :authenticate_user!
  before_filter :require_homestay!

  # GET /host
  def index
    @conversations = Mailbox.as_host(current_user)
    @unread_count  = @conversations.where(host_read: false).count
  end

  private
  def require_homestay!
    if current_user.homestay.blank?
      flash[:info] = 'Just fill in the form to create your Homestay!'
      redirect_to new_host_homestay_path
    end
  end
end
