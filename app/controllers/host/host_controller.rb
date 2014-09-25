class Host::HostController < ApplicationController
  layout 'new_application'

  before_filter :authenticate_user!
  before_filter :verify_homestay_existance!

  # GET /host
  def index
    @conversations = Mailbox.as_host(current_user)
    @unread_count  = @conversations.where(host_read: false).count
  end

  private
  def verify_homestay_existance!
    redirect_to new_homestay_path if current_user.homestay.blank?
  end
end
