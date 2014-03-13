class HomestaysController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, except: [:show, :index]
  before_filter :find_homestay, only: [:edit, :update]

  SEARCH_RADIUS = 20

  #This is the action that results from a search
  def index
    @search = Search.new(params[:search])
    #We are only doing australia, not sure why we are doing the country detect
    @search.country =  'AU' #request.location.country_code if request.location
    @title = "Pet care for #{@search.location}"
    respond_with @homestays = @search.perform.paginate(page: params[:page], per_page: 10)
  end

  def show
    @homestay = Homestay.find_by_slug(params[:id])
    raise ActiveRecord::RecordNotFound unless @homestay && @homestay.active?

    @title = @homestay.title
    @reviewed_ratings = @homestay.user.received_feedbacks.reviewed
    if current_user
	    @reusable_enquiries = current_user.enquiries.where(reuse_message: true)
      @enquiry = Enquiry.new({
        user: current_user,
        pets: current_user.pets,
        check_in_date: Date.today,
        check_out_date: Date.today
      })
    end
  end

  def update
    if @homestay.update_attributes(params[:homestay])
      redirect_to my_account_path, alert: 'Your listing has been updated.'
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
      flash[:new_homestay] = 'Nice, your PetHomeStay is ready for the world!'
      redirect_to @homestay
    else
      flash[:notice] = 'That title is not unique' if @homestay.errors[:slug].present?
      render :new
    end
  end

  def favourite
	  @homestay = Homestay.find params[:id]
		Favourite.create! homestay_id: @homestay.id, user_id: current_user.id
		render nothing: true
  end

  def non_favourite
	  @homestay = Homestay.find params[:id]
	  @fav = Favourite.where(homestay_id: @homestay.id, user_id: current_user.id).first
	  if @fav
		  @fav.destroy
		  render nothing: true
	  else
			render nothing: true, status: 302
		end
  end

  def favourites
	  @homestays = current_user.homestays
  end

  private
  def find_homestay
    @homestay = current_user.homestay
    raise ActiveRecord::RecordNotFound unless @homestay.slug == params[:id]
  end
end
