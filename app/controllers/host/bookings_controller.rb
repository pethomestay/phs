class Host::BookingsController < Host::HostController
  include BookingsHelper

  def index
    @bookings = current_user.bookees.valid_host_view_booking_states
  end
end
