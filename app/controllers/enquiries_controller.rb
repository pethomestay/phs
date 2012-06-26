class EnquiriesController < ApplicationController
	def create
    @enquiry = Enquiry.new(params[:enquiry])
    @enquiry.user = current_user
    if @enquiry.save
      redirect_to @enquiry.provider, alert: "Your enquiry has been sent to this provider."
    else
      redirect_to @enquiry.provider, error: "There was an issue with your request. Please contact support."
    end
  end
end
