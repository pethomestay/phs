class Api::PetsController < Api::BaseController

  before_filter :authenticate_user

  def index
    @pets = @user.pets.order(:id)
  end

  def create
    @pet = @user.pets.build(parsed_params)
    unless @pet.save
      render_400 @pet.errors.full_messages
    end
  end

  private

  def parsed_params
    unless params[:pet].blank?
      pet_params = params[:pet]
      pet_params[:pet_type_id] = pet_params.delete(:type)
      pet_params[:pet_age] = pet_params.delete(:age)
      pet_params[:sex_id] = pet_params.delete(:sex)
      pet_params[:size_id] = pet_params.delete(:size)
      pet_params[:personalities] = pet_params.delete(:personality)
    end
    pet_params
  end

end
