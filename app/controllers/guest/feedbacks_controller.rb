class Guest::FeedbacksController < Guest::GuestController
  respond_to :html
  before_filter :set_enquiry, except: [:index, :edit, :update]

  def index
    @feedbacks = current_user.given_feedbacks.order('created_at DESC').paginate(page: params[:page], per_page: 10) # feedbacks given as a guest
    @rec_feedbacks = current_user.received_feedbacks.order('created_at DESC').paginate(page: params[:page], per_page: 10)
    @recommendations = current_user.recommendations.order('created_at DESC').paginate(page: params[:page], per_page: 10)
    gon.push fb_app_id: ( ENV['APP_ID'] || '363405197161579' )
    render "guest/feedbacks/index", :layout => "new_application"
  end

  def create
    # The line below is causing an issue.
    @feedback = Feedback.new(params[:feedback], :subject_id => @enquiry.booking.bookee.id, :user_id => current_user.id)
    @feedback.subject_id = @enquiry.booking.bookee.id
    @feedback.user_id = current_user.id
    if @feedback.save!
      redirect_to guest_feedbacks_path, alert: 'Thanks for your feedback!'
    else
      render :new # <== Test that this works
    end
  end

  def new
    @user = current_user
    if involved_party(@enquiry) && @enquiry.feedbacks.find_by_user_id(current_user.id).nil?
      respond_with @feedback = @enquiry.feedbacks.build(user: current_user, subject: subject(@enquiry)), layout: 'new_application'
    else
      redirect_to guest_feedbacks_path, alert: 'Sorry! You have already left feedback'
    end
  end

  def edit
    @feedback = current_user.given_feedbacks.find(params[:id])
    redirect_to guest_feedbacks_path, :alert => "No feedback found" and return unless @feedback
    render  :layout => "new_application"
  end

  def update
    @feedback = current_user.given_feedbacks.find(params[:id])
    redirect_to guest_feedbacks_path, :alert => "No feedback found" and return unless @feedback
    @feedback.update_attributes(params[:feedback])
    @feedback.save
    redirect_to guest_feedbacks_path, alert: 'Feedback Updated!'
  end

  private
  def set_enquiry
    @enquiry = current_user.enquiries.find_by_id(params[:enquiry_id] || params[:feedback][:enquiry_id])
    if @enquiry.feedbacks.find_by_user_id(current_user.id).nil?
      return true
      # redirect_to guest_path,
      #   alert: "Thanks, you have already left feedback" and return
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
