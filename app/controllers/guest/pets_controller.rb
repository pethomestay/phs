class Guest::PetsController < Guest::GuestController
  respond_to :html

  # GET /guest/pets
  def index
    @pets = current_user.pets
    respond_with @pets
  end

  # GET /guest/pets/new
  def new
    @pet = current_user.pets.build
    respond_with @pet
  end
  end
end
