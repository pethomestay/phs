class FeedbacksController < ApplicationController
  before_filter :authenticate_user!

  def create
    @enquiry = Enquiry.find_by_id_and_owner_accepted(params[:enquiry_id], true)
    @subject = subject(@enquiry)
    @feedback = Feedback.find_or_create_by_user_id_and_enquiry_id_and_subject_id(current_user.id, @enquiry.id, @subject.id)
    if @feedback.update_attributes(params[:feedback])
      redirect_to my_account_path, alert: 'Thanks for your feedback!'
    else
      render :show
    end
  end

  def show
    @enquiry = Enquiry.find_by_id_and_owner_accepted(params[:enquiry_id], true)

    unless @enquiry
      redirect_to my_account_path
      return
    end

    if @enquiry.user == current_user
      @subject = @enquiry.homestay.user
    elsif @enquiry.homestay.user == current_user
      @subject = @enquiry.user
    else
      redirect_to my_account_path
      return
    end

    @feedback = Feedback.find_or_create_by_user_id_and_enquiry_id_and_subject_id(current_user.id, @enquiry.id, @subject.id)
  end

  def subject(enquiry)
    if enquiry.user == current_user
      @subject = enquiry.homestay.user
    elsif enquiry.homestay.user == current_user
      @subject = enquiry.user
    end
  end
end
