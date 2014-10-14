class Host::HostController < ApplicationController
  layout 'new_application'

  before_filter :authenticate_user!
  before_filter :require_homestay!
  before_filter :set_instance_vars
  # TODO: specify the order that before_filter runs

  # GET /host
  def index
    @conversations = Mailbox.as_host(current_user).paginate(page: params[:page], per_page: 10)
    render 'guest/guest/index'
  end

  private
  def require_homestay!
    if current_user.homestay.blank?
      flash[:info] = 'Create your Homestay to become a Host'
      redirect_to new_host_homestay_path
    end
  end

  def set_instance_vars
    @unread_count = Mailbox.as_host(current_user).where(host_read: false).count
    this_month    = Date.today..Date.today.end_of_month
    upcoming_b    = current_user.bookees.where(check_in_date: this_month).limit(5)
                    .select('state, check_in_date, check_out_date, booker_id')
    upcoming_e    = current_user.homestay.enquiries.includes(:booking)
                    .where(check_in_date: this_month)
                    .where( bookings: { enquiry_id: nil } ).limit(5)
                    .select('check_in_date, check_out_date')
    @upcoming     = (upcoming_e + upcoming_b).sort{ |a, b| a.check_in_date <=> b.check_in_date }
  end
end
