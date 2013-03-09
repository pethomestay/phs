class EnquiriesController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :find_enquiry, only: [:show, :update]

	def create
    @enquiry = Enquiry.new(params[:enquiry])
    @enquiry.user = current_user
    if @enquiry.save && ProviderMailer.enquiry(@enquiry).deliver
      redirect_to @enquiry.homestay, alert: "Your enquiry has been sent to this provider. They will respond with their availability soon."
    else
      redirect_to @enquiry.homestay, error: "There was an issue with your request. Please contact support."
    end
  end

  def show
    @user = @enquiry.user
    respond_with @enquiry
  end

  def update
    @enquiry.update_attributes(params[:enquiry])
    if @enquiry.accepted
      PetOwnerMailer.contact_details(@enquiry).deliver
      redirect_to my_account_path, alert: "Your contact details have been sent to #{enquiry.user.first_name}."
    else
      PetOwnerMailer.provider_unavailable(@enquiry).deliver
      redirect_to my_account_path, alert: "We'll let #{enquiry.user.first_name} know you're not available at this time."
    end
  end

  private
  def find_enquiry
    @enquiry = Enquiry.find_by_homestay_id_and_id!(current_user.homestay.id, params[:id])
  end
end
