class HomestaysController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, except: [:show, :index, :availability]

  SEARCH_RADIUS = 20

  #This is the action that results from a search
  def index
    redirect_to root_path and return unless params[:search]
    @search = Search.new(params[:search])
    #We are only doing australia, not sure why we are doing the country detect
    @search.country =  'Australia' #request.location.country_code if request.location
    @title = "Pet care for #{@search.location}"
    respond_with @homestays = @search.perform.paginate(page: params[:page], per_page: 10)
  end

  def rotate_image
      @image = UserPicture.find_by_id(params[:id])
      @image.file = @image.file.process(:rotate, 90)
      @image.save
      @new_url = @image.file.thumb('200x200').url
      respond_to do | format|
        format.js
      end
  end

  def show
    @homestay = Homestay.find_by_slug(params[:id])
    raise ActiveRecord::RecordNotFound unless @homestay
    notice = 'This listing is not active.'
    if @homestay.locked?
      notice = nil #we will change this to a message later
    end

    flash.now[:notice] = notice if notice && !@homestay.active?
    @title = @homestay.title
    @reviewed_ratings = @homestay.user.received_feedbacks.reviewed
    @response_rate_in_percent = @homestay.user.response_rate_in_percent
    if current_user
	    @reusable_enquiries = current_user.enquiries.where(reuse_message: true)
      @enquiry = Enquiry.new({
        user: current_user,
        pets: current_user.pets,
        check_in_date: Date.today,
        check_out_date: Date.today
      })
    end
    render layout: 'new_application'
  end

  def activate
    @homestay = Homestay.find_by_slug!(params[:homestay_id])
    if @homestay.active
      @homestay.active = false
    else
      @homestay.active = true
    end
    @homestay.save
    respond_to do | format|
      format.js
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

  def availability
    homestay = Homestay.find(params[:id])
    start_date = Time.at(params[:start].to_i).to_date
    end_date  = Time.at(params[:end].to_i).to_date
    info = homestay.user.booking_info_between(start_date, end_date)
    render json: info.to_json, status: 200
  end
end
