class EnquiriesController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :find_enquiry, only: [:show, :update]

  def create
    if params[:enquiry][:reuse_message] == '1'
      @old_reused_enquiry = current_user.enquiries.where(reuse_message: true)
      if @old_reused_enquiry.present?
        old_reused_enquiry = @old_reused_enquiry.first
        old_reused_enquiry.reuse_message = false
        old_reused_enquiry.save
      end
    end
    @enquiry = Enquiry.create(params[:enquiry].merge(user: current_user))
    if @enquiry.valid?
      flash[:alert] = 'Your enquiry has been sent to the Host, and there is a record in your My Account Inbox. Please enquire with at least 3 Hosts to have the best chance of availability. Thank you for using PetHomeStay!'
    else
      flash[:error] = @enquiry.errors.full_messages.first
    end
    redirect_to @enquiry.homestay
  end

  def show
    @user = @enquiry.user
    respond_with @enquiry
  end

  def update
    if @enquiry.update_attributes(params[:enquiry])
      @enquiry.mailbox.messages.create!(user_id: current_user.id, message_text: @enquiry.response_message) unless @enquiry.response_message.blank?
      return redirect_to mailbox_messages_path(@enquiry.mailbox)
    else
      flash[:alert] = 'Please fill in a response message if your are not answering yes or no'
      @user = @enquiry.user
      render :show
    end
  end

  private
  def find_enquiry
    @enquiry = Enquiry.find_by_homestay_id_and_id!(current_user.homestay.id, params[:id])
  end
end
