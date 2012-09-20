class HomestaysController < ApplicationController
  before_filter :authenticate_user!, except: [:show]

  rescue_from ActiveRecord::RecordNotFound, :with => :error_404

  def show
    @homestay = Homestay.find(params[:id])

    if !@homestay.active?
      redirect_to root_path, alert: "This listing no longer exists."
      return
    end
    
    @title = @homestay.title
    @reviewed_ratings = @homestay.user.received_feedbacks.reviewed
    if current_user
      @enquiry = Enquiry.new({
        user: current_user,
        pets: current_user.pets,
        date: Date.today
      })
    end
  end

  def edit
    unless current_user && @homestay = Homestay.find_by_user_id_and_id(current_user.id, params[:id])
      redirect_to root_path
    end
  end

  def update
    if current_user && @homestay = Homestay.find_by_user_id_and_id(current_user.id, params[:id])
      if @homestay.update_attributes(params[:homestay])
        redirect_to my_account_path, alert: "Your listing has been updated."
      else
        render :new
      end
    else
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
