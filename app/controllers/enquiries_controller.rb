class EnquiriesController < ApplicationController
	def create
    @enquiry = Enquiry.new(params[:enquiry])
    @enquiry.user = current_user
    if @enquiry.save && ProviderMailer.enquiry_email(@enquiry).deliver
      redirect_to @enquiry.homestay, alert: "Your enquiry has been sent to this provider."
    else
      redirect_to @enquiry.homestay, error: "There was an issue with your request. Please contact support."
    end
  end
end
