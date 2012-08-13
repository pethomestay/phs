class HomestaysController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :error_404

  def show
    @homestay = Homestay.find(params[:id])
    @title = @homestay.title
    @reviewed_ratings = @homestay.ratings.reviewed
    if current_user
      @my_rating = Rating.find_by_user_id_and_ratable_type_and_ratable_id(current_user.id, 'Homestay', params[:id])
      @enquiry = Enquiry.new({
        user: current_user,
        pets: current_user.pets,
        date: Date.today
      })
    end
  end

  def edit
    unless @homestay = Homestay.find_by_user_id_and_id(current_user.id, params[:id])
      redirect_to root_path
    end
  end

  def new
    if current_user
      @homestay = current_user.build_homestay
    else
      redirect_to root_path
    end
  end

  def create
    if current_user
      @homestay = current_user.build_homestay(params[:homestay])
      if @homestay.save
        redirect_to @homestay
      else
        render :new
      end
    else
      redirect_to root_path
    end
  end
end
