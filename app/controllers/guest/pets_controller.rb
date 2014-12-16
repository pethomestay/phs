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

  # POST /guest/pets
  def create
    @pet = current_user.pets.build(params[:pet])
    if @pet.save
      flash[:alert] = "#{@pet.name} has been added to your list of pets."
      if params[:redirect_path].present?
        redirect_to params[:redirect_path]
      else
        redirect_to guest_pets_path
      end
    else
      flash[:error] = @pet.errors.full_messages.first
      render :new
    end
  end

  # GET
  def edit
    @pet = current_user.pets.find(params[:id])
    respond_with @pet
  end

  # PUT
  def update
    @pet = current_user.pets.find(params[:id])
    if @pet.update_attributes(params[:pet])
      flash[:notice] = "#{@pet.name}'s info has been updated."
      redirect_to guest_pets_path
    else
      flash[:error] = @pet.errors.full_messages.first
      render :edit
    end
  end

  # DELETE
  def destroy
    @pet = current_user.pets.find(params[:id])
    @pet.destroy
    redirect_to guest_pets_path, alert: "#{ @pet.name } has been removed from your list of pets."
  end
end
