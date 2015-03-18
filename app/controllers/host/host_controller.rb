class Host::HostController < ApplicationController
  layout 'new_application'

  before_filter :host_filters
  before_filter :set_host_instance_vars
  # GET /host
  def index
    @conversations = Mailbox.as_host(current_user).paginate(page: params[:page], per_page: 10)
    render 'guest/guest/index'
  end

  def set_host_instance_vars
    @awaits_host_feedback = current_user.bookees.sort_by(&:check_in_date).select {|b| b.try(:enquiry).try(:feedbacks).try(:empty?) && view_context.translate_state(b.state) == 'Booked' }
  end

  private
  def host_filters
    if user_signed_in? # User must be signed in
      if current_user.homestay.present? # User must have a Homestay
        flash[:alert] = 'Your Homestay is not active yet. We will contact you\
                          within two business days to introduce PetHomeStay and\
                          approve your listing!' unless current_user.homestay.active?
        @unread_count = Mailbox.as_host(current_user).where(host_read: false).count
        # this_month    = Date.today..Date.today.end_of_month
        # upcoming_b    = current_user.bookees.where(check_in_date: this_month).limit(5)
        #                 .select('state, check_in_date, check_out_date, booker_id')
        # upcoming_e    = current_user.homestay.enquiries.includes(:booking)
        #                 .where(check_in_date: this_month)
        #                 .where( bookings: { enquiry_id: nil } ).limit(5)
        #                 .select('check_in_date, check_out_date')
        @upcoming     = current_user.bookees.sort_by(&:check_in_date).select {|b| b.check_out_date >= Date.today}
      else
        flash[:info] = 'Wanna share the love and be an awesome Host yourself? Create your own Homestay by simply filling the form!'
        redirect_to new_host_homestay_path
      end
    else
      flash[:info] = 'Please sign in or sign up before continuing :)'
      redirect_to new_user_session_path, redirect_path: request.env['PATH_INFO']
    end
  end
end
