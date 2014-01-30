class Admin::BookingsController < Admin::AdminController
	respond_to :html

	def index
		respond_with(:admin, @bookings = Booking.finished_and_host_accepted.order("created_at DESC"))
	end

	def reconciliations_file
		@bookings = Booking.finished_and_host_accepted.order("created_at DESC")
		respond_to do |format|
			format.csv { send_data @bookings.to_csv }
		end
	end

end
