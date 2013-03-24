class Admin::EnquiriesController < Admin::AdminController
  respond_to :html

  def index
    respond_with(:admin, @enquiries = Enquiry.includes([{homestay: :user}, :user]))
  end

  def show
    respond_with(:admin, @enquiry = Enquiry.find(params[:id]))
  end

  def new
    respond_with(:admin, @enquiry = Enquiry.new)
  end

  def edit
    respond_with(:admin, @enquiry = Enquiry.find(params[:id]))
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
