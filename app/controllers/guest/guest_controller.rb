class Guest::GuestController < ApplicationController
  layout 'new_application'

  before_filter :authenticate_user!
  before_filter :unread_count
  # TODO: specify the order that before_filter runs

  # GET /guest
  def index
    @conversations = Mailbox.as_guest(current_user).paginate(page: params[:page], per_page: 10)
  end

  private
  def unread_count
    @unread_count  = Mailbox.as_guest(current_user).where(guest_read: false).count
  end
end
