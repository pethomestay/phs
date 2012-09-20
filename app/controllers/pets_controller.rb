class PetsController < ApplicationController
  before_filter :authenticate_user!

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
    @pet = Pet.find_by_user_id_and_id(current_user.id, params[:id])

    unless @pet
      redirect_to my_account_path
      return
    end
  end

  def update
    @pet = Pet.find_by_user_id_and_id(current_user.id, params[:id])

    unless @pet
      redirect_to my_account_path
      return
    end

    if @pet.update_attributes(params[:pet])
      redirect_to pets_path, alert: "#{@pet.name}'s info has been updated."
    else
      render :edit
    end
  end

  def destroy
    @pet = Pet.find_by_user_id_and_id(current_user.id, params[:id])

    unless @pet
      redirect_to my_account_path
      return
    end

    pet_name = @pet.name
    @pet.destroy
    redirect_to pets_path, alert: "#{pet_name} has been removed from your list of pets."
  end
end
