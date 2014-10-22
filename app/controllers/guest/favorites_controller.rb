class Guest::FavoritesController < Guest::GuestController
  # GET /guest/favorites
  def index
    @favorites = current_user.homestays
    @hosts_with_bookings = current_user.bookers.booked.group_by { |b| b.bookee }
  end
end
