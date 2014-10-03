class Host::HostController < ApplicationController
  layout 'new_application'

  before_filter :authenticate_user!
  before_filter :require_homestay!
  before_filter :unread_count
  # TODO: specify the order that before_filter runs

  # GET /host
  def index
    @conversations = Mailbox.as_host(current_user).paginate(page: params[:page], per_page: 10)
    render 'guest/guest/index'
  end

  private
  def require_homestay!
    if current_user.homestay.blank?
      flash[:info] = 'Just fill in the form to create your Homestay!'
      redirect_to new_host_homestay_path
    end
  end

  def unread_count
    @unread_count  = Mailbox.as_host(current_user).where(host_read: false).count
  end
end
