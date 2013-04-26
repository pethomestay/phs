class HomestaysController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, except: [:show, :index]
  before_filter :find_homestay, only: [:edit, :update]

  SEARCH_RADIUS = 20

  #This is the action that results from a search
  def index
    @search = Search.new(params[:search])
    @search.country = request.location.country_code if request.location
    @title = "Pet care for #{@search.location}"
    respond_with @homestays = @search.perform.paginate(page: params[:page], per_page: 10)
  end

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
