class Admin::PetsController < Admin::AdminController
  respond_to :html

  def index
    respond_with(:admin, @pets = Pet.all)
  end

  def show
    respond_with(:admin, @pet = Pet.find(params[:id]))
  end

  def new
    respond_with(:admin, @pet = Pet.new)
  end

  def edit
    respond_with(:admin, @pet = Pet.find(params[:id]))
  end

  def create
    respond_with(:admin, @pet = Pet.create(params[:pet]))
  end

  def update
    @pet = Pet.find(params[:id])
    @pet.update_attributes(params[:pet])
    respond_with(:admin, @pet)
  end

  def destroy
    @pet = Pet.find(params[:id])
    @pet.destroy

    respond_with(:admin, @pet)
  end
end
