class FeedbacksController < ApplicationController
  respond_to :html
  before_filter :set_enquiry
  before_filter :authenticate_user!

  def create
    @feedback = @enquiry.feedbacks.create({user: current_user, subject: subject(@enquiry)}.merge(params[:feedback]))
    if @feedback.valid?
      redirect_to root_path, alert: 'Thanks for your feedback!'
    else
      render :new
    end
  end

  def new
    if involved_party(@enquiry)
      respond_with @feedback = @enquiry.feedbacks.build(user: current_user, subject: subject(@enquiry))
    else
      render file: "#{Rails.root}/public/404", format: :html, status: 404
    end
  end

  private

  def subject(enquiry)
    enquiry.user == current_user ? enquiry.homestay.user : enquiry.user
  end

  def involved_party(enquiry)
    enquiry.user == current_user || enquiry.homestay.user == current_user
  end

  def set_enquiry
    @enquiry = Enquiry.find_by_id_and_owner_accepted(params[:enquiry_id], true) || current_user.enquiries.find_by_id(params[:enquiry_id])
    redirect_to root_path and return if @enquiry.nil?
  end
end
