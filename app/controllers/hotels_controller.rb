class HotelsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :error_404
  
  def show
    @hotel = Hotel.active.find(params[:id])
    @title = @hotel.title
    @reviewed_ratings = @hotel.ratings.reviewed
    if current_user
      @my_rating = Rating.find_by_user_id_and_ratable_type_and_ratable_id(current_user.id, 'Hotel', params[:id])
      @enquiry = Enquiry.new({
        user: current_user,
        pets: current_user.pets,
        date: Date.today
      })
    end
  end

  def edit
    if @hotel = Hotel.find_by_user_id_and_id(current_user.id, params[:id])

    else
      redirect_to root_path
    end
  end
end
