class EnquiriesController < ApplicationController
	def create
    @enquiry = Enquiry.new(params[:enquiry])
    @enquiry.user = current_user
    if @enquiry.save && ProviderMailer.enquiry_email(@enquiry).deliver
      redirect_to @enquiry.homestay, alert: "Your enquiry has been sent to this provider. They will respond with their availability soon."
    else
      redirect_to @enquiry.homestay, error: "There was an issue with your request. Please contact support."
    end
  end

  def show
    @enquiry = Enquiry.find(params[:id])
    @user = @enquiry.user
    @pets = @user.pets
    redirect_to my_account_path if @enquiry.homestay != current_user.homestay
  end
end
