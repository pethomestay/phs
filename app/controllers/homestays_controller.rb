class HomestaysController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  before_filter :find_homestay, only: [:edit, :update]

  def show
    @homestay = Homestay.find_by_slug(params[:id])
    raise ActiveRecord::RecordNotFound unless @homestay && @homestay.active?

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

  end

  def update
    if @homestay.update_attributes(params[:homestay])
      redirect_to my_account_path, alert: "Your listing has been updated."
    else
      render :edit
    end
  end

  def new
    @homestay = current_user.build_homestay
  end

  def create
    @homestay = current_user.build_homestay(params[:homestay])
    if @homestay.save
      flash[:new_homestay] = "Nice, your PetHomeStay is ready for the world!"
      redirect_to @homestay
    else
      render :new
    end
  end

  private
  def find_homestay
    @homestay = current_user.homestay
    raise ActiveRecord::RecordNotFound unless @homestay.slug == params[:id]
  end
end
