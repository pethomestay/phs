class FeedbacksController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!

  def create
    @enquiry = Enquiry.find_by_id_and_owner_accepted!(params[:enquiry_id], true)
    @feedback = @enquiry.feedbacks.create({user: current_user, subject: subject(@enquiry)}.merge(params[:feedback]))
    if @feedback.valid?
      redirect_to guest_path, alert: 'Thanks for your feedback!'
    else
      render :new
    end
  end

  def new
    @enquiry = Enquiry.find_by_id_and_owner_accepted!(params[:enquiry_id], true)
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
end
