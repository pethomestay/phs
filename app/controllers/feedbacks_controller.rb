class FeedbacksController < ApplicationController
  def create
    @enquiry = Enquiry.find_by_id_and_owner_accepted(params[:enquiry_id], true)
    @subject = subject(@enquiry)
    @feedback = Feedback.find_or_create_by_user_id_and_enquiry_id_and_subject_id(current_user.id, @enquiry.id, @subject.id)
    if @feedback.update_attributes(params[:feedback])
      redirect_to my_account_path, alert: 'Thanks for your feedback!'
    else
      render :show
    end
    # if current_user
    #   klass = env['PATH_INFO'].split('/').second.singularize.capitalize
    #   @rating = Rating.find_or_create_by_user_id_and_ratable_type_and_ratable_id(current_user.id, klass, params[:homestay_id])
    #   @rating.update_attributes(params[:rating])
    #   render json: @rating.to_json
    # else
    #   render nothing: true, status: 401
    # end
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
