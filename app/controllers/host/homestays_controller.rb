class Host::HomestaysController < Host::HostController
  before_filter :authenticate_user!, only: [:new, :create]
  before_filter :update_user_mobile_number, only: [:create, :update]
  skip_before_filter :host_filters,  only: [:new, :create]

  # GET /host/homestay/new
  def new
    redirect_to edit_host_homestay_path and return if current_user.homestay.present?
    Intercom::Event.create(:event_name => "viewed My Homestay box", :email => current_user.email, :created_at => Time.now.to_i)
    @homestay = current_user.build_homestay
  end

  # POST
  def create
    @homestay = current_user.build_homestay(params[:homestay])
    if @homestay.save
      flash[:notice] = 'Thank you for applying to join the PetHomeStay Host Community! We will contact you within two business days to introduce PetHomeStay and approve your listing!'
      #Send email to let them know that their homestay has been created and is ready for approval
      #### DELETE THIS ONCE YOU START USING INTERCOM
      HomestayCreatedJob.new.async.perform(@homestay)
      #Send email to admin to let them know currently not needed but can be activated later
      #AdminMailer.delay.homestay_created_admin(@homestay.id)
      Intercom::Event.create(:event_name => "Created a Homestay", :email => current_user.email, :created_at => Time.now.to_i)
      redirect_to @homestay
    else
      flash[:notice] = 'That title is not unique' if @homestay.errors[:slug].present?
      flash[:error] = @homestay.errors[:base][0] if @homestay.errors[:base].present?
      render :new
    end
  end

  # GET /host/homestay/edit
  def edit
    @homestay = current_user.homestay
    raise ActiveRecord::RecordNotFound if @homestay.blank?
    if not @homestay.active?
      flash[:alert] = 'This listing is not active.'
    elsif @homestay.locked?
      flash[:alert] = 'This listing is locked.'
    end
  end

  def update
    @homestay = current_user.homestay
    raise ActiveRecord::RecordNotFound if @homestay.blank?
    if @homestay.update_attributes(params[:homestay])
      redirect_to @homestay, alert: 'Your listing has been updated.'
    else
      render :edit
    end
  end

  private
  def update_user_mobile_number
    if params[:mobile_number].present?
      current_user.update_attribute(:mobile_number, params[:mobile_number])
    end
  end
end
