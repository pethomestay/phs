class Guest::GuestController < ApplicationController
  layout 'new_application'

  before_filter :authenticate_user!

  # GET /guest
  def index
    @conversations = Mailbox.as_guest(current_user)
    @unread_count  = @conversations.where(guest_read: false).count
  end
end
