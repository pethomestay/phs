class EnquiriesController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :find_enquiry, only: [:show, :update]

	def create
    @enquiry = Enquiry.create(params[:enquiry].merge(user: current_user))
    if @enquiry.valid?
      flash[:alert] = "Your enquiry has been sent to this provider. They will respond with their availability soon."
    else
      flash[:error] = "There was an issue with your request. Please contact support."
    end
    redirect_to @enquiry.homestay
  end

  def show
    @user = @enquiry.user
    respond_with @enquiry
  end

  def update
    if @enquiry.update_attributes(params[:enquiry])
      redirect_to my_account_path, alert: "Your response has been sent to #{@enquiry.user.first_name}"
    else
      flash[:alert] = "Please fill in a response message if your are not answering yes or no"
      @user = @enquiry.user
      render :show
    end
  end

  private
  def find_enquiry
    @enquiry = Enquiry.find_by_homestay_id_and_id!(current_user.homestay.id, params[:id])
  end
end
