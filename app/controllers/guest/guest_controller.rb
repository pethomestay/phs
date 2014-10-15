class Guest::GuestController < ApplicationController
  layout 'new_application'

  before_filter :authenticate_user!
  before_filter :set_instance_vars
  # TODO: specify the order that before_filter runs

  # GET /guest
  def index
    @conversations = Mailbox.as_guest(current_user).paginate(page: params[:page], per_page: 10)
  end

  private
  def set_instance_vars
    @unread_count = Mailbox.as_guest(current_user).where(guest_read: false).count
    this_month    = Date.today..Date.today.end_of_month
    @upcoming     = current_user.bookers.where(check_in_date: this_month)
                    .order('check_in_date ASC').limit(5)
                    .select('state, check_in_date, check_out_date, bookee_id')
  end
end
