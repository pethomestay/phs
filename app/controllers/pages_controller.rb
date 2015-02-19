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
    @enquiry = Enquiry.find(params[:ref].to_i)
    @host = @enquiry.booking.bookee if @enquiry.booking.bookee.mobile_number.gsub(/\s+/,"").split(//).last(5).join == params[:from].split(//).last(5).join
    return unless @host && @host.admin? # Remove @host.admin? to enable for all users
    @guest = @enquiry.booking.booker
    if (params[:message] =~ /^yes/i).present? # Sends interested SMS content to guest
      message = "PHS HOST RESPONSE from #{@host.first_name}, #{@host.homestay.address_postcode}: "
      message += @host.homestay.auto_interest_sms || @host.homestay.default_auto_interest_sms
      send_sms(to: @guest, text: message, ref: @enquiry.id)
      @enquiry.booking.mailbox.messages.create(:user_id => @host.id, :message_text => message)
    elsif (params[:message] =~ /^no/i).present? # Sends declined SMS content to guest
      # Reject the booking
      @enquiry.booking.update_column(:state, "rejected")
    else
      @enquiry.booking.mailbox.messages.create(:user_id => @host.id, :message_text => params[:message])
    end
    render nothing: true
  end
end
