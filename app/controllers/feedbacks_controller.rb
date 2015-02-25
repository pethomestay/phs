class FeedbacksController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  # before_filter :set_enquiry, except: [:index, :edit]
  # skip_before_filter :track_session_variables, only: [:create, :index]


  def index
    @feedbacks = current_user.given_feedbacks # feedbacks given as a guest
    @user = current_user 
    gon.push fb_app_id: ( ENV['APP_ID'] || '363405197161579' )
    render :layout => "new_application"
  end

  def create
    @feedback = @enquiry.feedbacks.create({user: current_user, subject: subject(@enquiry)}.merge(params[:feedback]))
    if @feedback.valid?
      redirect_to guest_path, alert: 'Thanks for your feedback!'
    else
      render :new
    end
  end

  def new
    @user = current_user
    if involved_party(@enquiry)
      respond_with @feedback = @enquiry.feedbacks.build(user: current_user, subject: subject(@enquiry)), layout: 'new_application'
    else
      render file: "#{Rails.root}/public/404", format: :html, status: 404
    end
  end

  def edit
    @feedback = @enquiry.feedback.find_by_id(params[:feedback_id])
    render  :layout => "new_application"
  end

  private
  def set_enquiry
    @enquiry = current_user.homestay.enquiries.find_by_id(params[:enquiry_id])
    if @enquiry.feedbacks.find_by_user_id(current_user.id).nil?
      return true
    elsif @enquiry.booking.host_accepted == false && @enquiry.booking.owner_accepted == false
      redirect_to guest_path,
        alert: 'The Homestay booking has not been completed yet.' and return
    end
  end

  def subject(enquiry)
    enquiry.user == current_user ? enquiry.homestay.user : enquiry.user
  end

  def involved_party(enquiry)
    enquiry.user == current_user || enquiry.homestay.user == current_user
  end
end
