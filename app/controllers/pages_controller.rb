class PagesController < ApplicationController
  include ShortMessagesHelper
  layout 'new_application'
  before_filter :authenticate_user!, only: [:welcome]

  def home
    @check_for_coupon = params[:check_for_coupon].present? && current_user.try(:admin)
    @homepage = true
    if params[:code].present?
      cookies[:code] = params[:code]
      redirect_to root_path and return
    end
  end

  # Launch point for iOS web views.
  def launch
    user = User.find_by_hex(params[:user_token])
    if user.blank?
      redirect_to root_path, notice: 'Authentication failed.'
    else
      sign_in(:user, user)
      redirect_to params[:path]
    end
  end

  def partners
    @contact = Contact.new
  end

  def welcome; end

  def why_join_pethomestay; end

  def our_company; end

  def the_team; end

  def investors; end

  def jobs; end

  def in_the_press; end

  def charity_hosts; end

  # Receives the reply SMS from Hosts via SMSBroadcast
  def receive_sms
    @enquiry = Enquiry.find(enquiry_id)
    render nothing: true and return unless @enquiry
    @host = @enquiry.booking.bookee if @enquiry.booking.bookee.mobile_number.gsub(/\s+/,"").split(//).last(5).join == params[:from].split(//).last(5).join
    render nothing: true and return unless @host #&& @host.admin? Remove @host.admin? to enable for all users
    @guest = @enquiry.booking.booker

    # Check that this is the first response from the host
    render nothing: true and return unless @enquiry.mailbox.messages.where(:user_id => @enquiry.mailbox.host_mailbox_id).count == 0

    # Handle message
    if (params[:message] =~ /^yes/i).present? # Sends interested SMS content to guest
      message = "PHS HOST RESPONSE from #{@host.first_name}, #{@host.homestay.address_postcode}: "
      message += @host.homestay.auto_interest_sms_text
      send_sms(to: @guest, text: message, ref: @enquiry.id)
      @enquiry.booking.mailbox.messages.create(:user_id => @host.id, :message_text => message)
    elsif (params[:message] =~ /^no/i).present? # Sends declined SMS content to guest
      # Reject the booking
      @enquiry.booking.update_column(:state, "rejected")
      message_content = @host.homestay.auto_decline_sms_text
      @enquiry.booking.mailbox.messages.create(:user_id => @host.id, :message_text => message_content )
    else
      @enquiry.booking.mailbox.messages.create(:user_id => @host.id, :message_text => params[:message])
    end

    render nothing: true
  end
end
