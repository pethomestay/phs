class Guest::GuestController < ApplicationController
  layout 'new_application'

  before_filter :authenticate_user!

  # GET /guest
  def index
    @conversations = Mailbox.as_guest(current_user).paginate(page: params[:page], per_page: 10)
    @unread_count  = @conversations.where(guest_read: false).count
  end
end
