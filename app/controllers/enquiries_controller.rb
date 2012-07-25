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

  def update
    enquiry = Enquiry.find_by_homestay_id_and_id(current_user.homestay.id, params[:id])
    if enquiry
      enquiry.update_attributes(params[:enquiry])
      if enquiry.accepted
        redirect_to my_account_path, alert: "Your contact details have been sent to #{enquiry.user.first_name}. Their details have also been emailed to you."
      else
        redirect_to my_account_path, alert: "We'll let #{enquiry.user.first_name} know you're not available at this time."
      end
    else
      redirect_to my_account_path
    end
  end
end
