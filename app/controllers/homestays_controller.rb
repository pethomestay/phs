class HomestaysController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, except: [:show, :index, :availability]
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

  def edit
    show()
  end

  def update
    if @homestay.update_attributes(params[:homestay])
      redirect_to my_account_path, alert: 'Your listing has been updated.'
    else
      render :edit
    end
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

  def new
    @homestay = current_user.build_homestay
  end

  def create
    @homestay = current_user.build_homestay(params[:homestay])
    if @homestay.save
      flash[:notice] = 'Thank you for applying to join the PetHomeStay Host Community! We will contact you within two business days to introduce PetHomeStay and approve your listing!'
      #Send email to let them know that their homestay has been created and is ready for approval
      HomestayCreatedJob.new.async.perform(@homestay)
      #Send email to admin to let them know currently not needed but can be activated later
      #AdminMailer.delay.homestay_created_admin(@homestay.id)
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

  def availability
    homestay = Homestay.find(params[:id])
    start_date = Time.at(params[:start].to_i).to_date
    end_date  = Time.at(params[:end].to_i).to_date
    info = homestay.user.booking_info_between(start_date, end_date)
    render json: info.to_json, status: 200
  end

  private
  def find_homestay
    @homestay = current_user.homestay
    raise ActiveRecord::RecordNotFound unless @homestay.slug == params[:id]
  end
end
