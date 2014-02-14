class Admin::PetsController < Admin::AdminController
  respond_to :html

  def index
    respond_with(:admin, @pets = Pet.order('created_at DESC'))
  end

  def show
    respond_with(:admin, @pet = Pet.find(params[:id]))
  end

  def new
    @pet = Pet.new
    if @pet.date_of_birth.nil?
      @pet.date_of_birth = Date.today
    end
    respond_with(:admin, @pet)
  end

  def edit
    @pet = Pet.find(params[:id])
    if @pet.date_of_birth.nil?
      @pet.date_of_birth = Date.today
    end
    respond_with(:admin, @pet)
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
