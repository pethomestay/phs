class Host::HomestaysController < Host::HostController
  skip_before_filter :require_homestay!, only: [:new, :create]

  # GET /host/homestay/new
  def new
    @homestay = current_user.build_homestay
  end

  # POST
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

  # GET /host/homestay/edit
  def edit
    @homestay = current_user.homestay
    raise ActiveRecord::RecordNotFound unless @homestay
    if not @homestay.active?
      flash[:alert] = 'This listing is not active.'
    elsif @homestay.locked?
      flash[:alert] = 'This listing is locked.'
    end
  end

  def update
    @homestay = current_user.homestay
    raise ActiveRecord::RecordNotFound unless @homestay.slug == params[:id]
    if @homestay.update_attributes(params[:homestay])
      redirect_to @homestay, alert: 'Your listing has been updated.'
    else
      render :edit
    end
  end
end
