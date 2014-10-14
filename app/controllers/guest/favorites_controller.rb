class Guest::FavoritesController < Guest::GuestController
  # GET /guest/favorites
  def index
    @favorites = current_user.homestays
  end
end
