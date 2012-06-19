class HotelsController < ApplicationController
  def show
    @hotel = Hotel.find(params[:id])
    @reviewed_ratings = @hotel.ratings.reviewed
    if current_user
      @my_rating = Rating.find_by_user_id_and_ratable_type_and_ratable_id(current_user.id, 'Hotel', params[:id])
    end
  end

  def edit
    if @hotel = Hotel.find_by_user_id_and_id(current_user.id, params[:id])

    else
      redirect_to root_path
    end
  end
end
