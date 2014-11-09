class Host::BookingsController < Host::HostController
  include BookingsHelper

  def index
    @bookings = current_user.bookees.sort_by(&:check_in_date).reverse
  end
end
