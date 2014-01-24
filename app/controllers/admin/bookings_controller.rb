class Admin::BookingsController < Admin::AdminController
	respond_to :html

	def index
		respond_with(:admin, @bookings = Booking.finished_and_host_accepted.order("created_at DESC"))
	end

end
