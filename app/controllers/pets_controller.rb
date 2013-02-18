class PetsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_pet, except: [:index, :new, :create]

  def index
    @pets = current_user.pets
  end

  def new
    @pet = current_user.pets.build
  end

  def create
    @pet = current_user.pets.build(params[:pet])
    if @pet.save
      if params[:redirect_path].present?
        redirect_to params[:redirect_path], alert: "#{@pet.name} has been added to your list of pets."
      else
        redirect_to pets_path, alert: "#{@pet.name} has been added to your list of pets."
      end
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @pet.update_attributes(params[:pet])
      redirect_to pets_path, alert: "#{@pet.name}'s info has been updated."
    else
      render :edit
    end
  end

  def destroy
    pet_name = @pet.name
    @pet.destroy
    redirect_to pets_path, alert: "#{pet_name} has been removed from your list of pets."
  end

  private
  def find_pet
    @pet = current_user.pets.find(params[:id])
  end
end
