class Guest::PetsController < Guest::GuestController
  # GET /guest/pets
  def index
  end

  # GET /guest/pets/new
  def new
    @pet = Pet.new
  end
end
