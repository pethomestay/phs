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
    @enquiry.update_attributes(params[:enquiry])
    flash[:alert] = @enquiry.accepted ? "Your contact details have been sent to #{@enquiry.user.first_name}." :
                                        "We'll let #{@enquiry.user.first_name} know you're not available at this time."
    redirect_to my_account_path
  end

  private
  def find_enquiry
    @enquiry = Enquiry.find_by_homestay_id_and_id!(current_user.homestay.id, params[:id])
  end
end
