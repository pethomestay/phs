class Admin::FeedbacksController < Admin::AdminController
  respond_to :html

  def index
    respond_with(:admin, @feedbacks = Feedback.order('created_at DESC'))
  end

  def show
    respond_with(:admin, @feedback = Feedback.find(params[:id]))
  end

  def new
    respond_with(:admin, @feedback = Feedback.new(params[:feedback]))
  end

  def edit
    respond_with(:admin, @feedback = Feedback.find(params[:id]))
  end

  def create
    respond_with(:admin, @feedback = Feedback.create(params[:feedback]))
  end

  def update
    @feedback = Feedback.find(params[:id])
    @feedback.update_attributes(params[:feedback])
    respond_with(:admin, @feedback)
  end

  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy

    respond_with(:admin, @feedback)
  end
end
