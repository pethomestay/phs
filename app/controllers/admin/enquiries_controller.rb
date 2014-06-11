class Admin::EnquiriesController < Admin::AdminController
  respond_to :html

  def index
    respond_with(:admin, @enquiries = Enquiry.order('created_at DESC').includes([{homestay: :user}, :user]))
  end

  def show
    respond_with(:admin, @enquiry = Enquiry.find(params[:id]))
  end

  def new
    @enquiry = Enquiry.new
    @enquiry.check_in_date = DateTime.now
    @enquiry.check_out_date = DateTime.now
    @enquiry.check_in_time = DateTime.now
    @enquiry.check_out_time = DateTime.now
    respond_with(:admin, @enquiry)
  end

  def edit
    @enquiry = Enquiry.find(params[:id])
    if @enquiry.check_out_time.nil?
      if @enquiry.check_out_date.nil?
        @enquiry.check_out_date = Date.today
      end
      @enquiry.check_out_time = DateTime.new(@enquiry.check_out_date.year,@enquiry.check_out_date.month,@enquiry.check_out_date.day,0,0,0)
    end
    if @enquiry.check_in_time.nil?
      if @enquiry.check_in_date.nil?
        @enquiry.check_in_date = Date.today
      end
      @enquiry.check_in_time = DateTime.new(@enquiry.check_in_date.year,@enquiry.check_in_date.month,@enquiry.check_in_date.day,0,0,0)
    end

    respond_with(:admin, @enquiry)
  end

  def create
    respond_with(:admin, @enquiry = Enquiry.create(params[:enquiry]))
  end

  def update
    @enquiry = Enquiry.find(params[:id])
    @enquiry.update_attributes(params[:enquiry])
    respond_with(:admin, @enquiry)
  end

  def destroy
    @enquiry = Enquiry.find(params[:id])
    @enquiry.destroy

    respond_with(:admin, @enquiry)
  end
end
