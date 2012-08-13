class ConfirmationsController < ApplicationController
  def show
    @enquiry = Enquiry.find(params[:enquiry_id])
    @homestay = @enquiry.homestay
    @provider = @homestay.user
    redirect_to my_account_path if @enquiry.user != current_user
  end

  def update
    enquiry = Enquiry.find_by_user_id_and_id(current_user.id, params[:enquiry_id])
    if enquiry
      enquiry.update_attributes(params[:enquiry])
      if enquiry.owner_accepted
        ProviderMailer.owner_confirmed(enquiry).deliver
        PetOwnerMailer.enquiry_reciept(enquiry).deliver
        redirect_to my_account_path, alert: "You've confirmed that #{enquiry.homestay.user.first_name} will handle your booking."
      else
        ProviderMailer.owner_canceled(enquiry).deliver
        redirect_to my_account_path, alert: "We'll let #{enquiry.homestay.user.first_name} know you've decided to go with someone else."
      end
    else
      redirect_to my_account_path
    end
  end
end