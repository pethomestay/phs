class FeedbacksController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!

  def create
    @enquiry = Enquiry.find_by_id!(params[:enquiry_id])
    redirect_to guest_path, alert: "Thanks, you have already left feedback" and return if @enquiry.feedbacks.any?
    if @enquiry.booking.host_accepted != true && @enquiry.booking.owner_accepted != true
      redirect_to guest_path, alert: 'The Homestay booking has not been completed yet.'
      return
    end
    @feedback = @enquiry.feedbacks.create({user: current_user, subject: subject(@enquiry)}.merge(params[:feedback]))
    if @feedback.valid?
      redirect_to guest_path, alert: 'Thanks for your feedback!'
    else
      render :new
    end
  end

  def new
    @enquiry = Enquiry.find_by_id!(params[:enquiry_id])
    if @enquiry.booking.nil? or @enquiry.booking.payment.nil?
      redirect_to guest_path, alert: 'Host has not confirmed this Homestay!'
      return
    end
    if involved_party(@enquiry)
      respond_with @feedback = @enquiry.feedbacks.build(user: current_user, subject: subject(@enquiry)), layout: 'new_application'
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
