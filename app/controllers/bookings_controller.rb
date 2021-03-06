class BookingsController < ApplicationController
  include BookingsHelper
  before_filter :authenticate_user!
  before_filter :homestay_required, only: [:index, :new]

  def index
    @bookings = current_user.bookees.valid_host_view_booking_states
  end

  def new
    @booking = current_user.find_or_create_booking_by(@enquiry, @homestay)
    redirect_to edit_booking_path(@booking)
  end

  def update_dates
    @booking = current_user.bookers.find_by_id(params[:booking_id])
    @booking.update_transaction_by(nil, params[:new_check_in], params[:new_check_out])
    @booking.update_attribute(:host_accepted, nil)
    render json: {:nights => @booking.number_of_nights, :total_cost => sprintf('%.2f', @booking.amount.to_s)}
  end

  def edit
    @booking = current_user.bookees.find_by_id(params[:id]) || current_user.bookers.find_by_id(params[:id])
    return redirect_to root_path, :alert => "Sorry no booking found" if @booking.nil?
    @host_view = @booking.bookee == current_user
    if !@host_view
      if current_user.used_coupons.any?
        @coupon = current_user.used_coupons.merge(CouponUsage.unused).last
      end
      @booking.update_attribute(:amount, @booking.calculate_amount) # Re-do calculations for all future transactions because remove CC surcharge
      @client_token = current_user.braintree_customer_id.present? ? Braintree::ClientToken.generate(:customer_id => current_user.braintree_customer_id ) : Braintree::ClientToken.generate()
    end
    render :edit, :layout => 'new_application'
    # @transaction = current_user.find_or_create_transaction_by(@booking)
    # @unavailable_dates = @booking.bookee.unavailable_dates_after(Date.today)
    # if @booking.state?(:payment_authorisation_pending) #we have tried to pay for this booking before display the ring admin screen
    #   PaymentFailedJob.new.async.perform(@booking, @transaction)
    #   render "bookings/payment_issue"
    # end
  end

  def owner_receipt
    @booking = current_user.bookers.find_by_id(params[:id])
    redirect_to guest_messages_path, :notice => "Sorry no receipt found" and return if @booking.nil?
    render :owner_receipt, :layout => 'new_application'
  end

  def guest_receipt
    @booking = current_user.bookers.find_by_id(params[:booking_id])
    if @booking.nil?
      redirect_to guest_messages_path, notice: 'Sorry no receipt found'
    else
      render :guest_receipt, layout: 'new_application'
    end
  end

  def host_receipt
    @booking = current_user.bookees.find_by_id(params[:booking_id])
    if @booking.nil?
      redirect_to host_messages_path, notice: 'Sorry no receipt found'
    else
      render :host_receipt, layout: 'new_application'
    end
  end

  def update
    @booking = current_user.bookees.find_by_id(params[:id]) || current_user.bookers.find_by_id(params[:id])
    if @booking.bookee == current_user # Host booking modifications
      if params[:commit] == "Decline Booking" # Host has rejected the booking
        message_content = (params[:booking][:message].blank? ? "Sorry, the host has declined the booking" : params[:booking][:message])
        @booking.mailbox.messages.create(:user_id => current_user.id, :message_text => message_content)
        @booking.update_column(:host_accepted, false)
        @booking.update_column(:state, "rejected")
        return redirect_to host_messages_path, :alert => "Declined booking"
      end
      if @booking.owner_accepted
        @booking.update_attributes!(params[:booking])
        if params[:booking][:host_accepted] == "false"
#          AdminMailer.host_rejected_paid_booking(@booking).deliver
          @booking.mailbox.update_attributes host_read: false, guest_read: false
          return redirect_to host_messages_path, :alert => "Informed #{@booking.booker.name} of rejected booking"
        else
          message = @booking.confirmed_by_host(current_user)
          return redirect_to host_messages_path, alert: message
        end
      else
        # This is updating a custom rate
        if @booking.update_transaction_by_daily_price(params[:booking][:cost_per_night])
          @booking.mailbox.update_attributes host_read: false, guest_read: false
          @booking.mailbox.messages.create(:user_id => current_user.id, :message_text => params[:booking][:message]) unless params[:booking][:message].blank?
          @booking.update_attribute(:host_accepted, true)
          return redirect_to host_messages_path, alert: "Custom rate has been sent to #{@booking.booker.first_name}"
        else
          return redirect_to host_messages_path, error: 'Sorry, your custom rate did not go through for some reason. Please try again or contact us at info@pethomestay.com.'
        end
      end
    else # Guest booking modifications (or payment)
      if current_user.used_coupons.merge(CouponUsage.unused).any?
        @coupon = current_user.used_coupons.merge(CouponUsage.unused).last
        payment_amount = (@coupon.discount_is_percentage ? @booking.amount * ( 1 - (@coupon.discount_amount / 100)) : (@booking.amount - @coupon.discount_amount)).to_s
      else
        payment_amount = @booking.amount.to_s
      end
      submit_payment = @booking.host_accepted == true ? true : false
      if params[:payment_method_nonce].present? # Payment was made
        # Create a customer in BrainTree if the user has never paid via BrainTree before
        if current_user.braintree_customer_id.nil? && Rails.env == "production"
          customer_create_result = Braintree::Customer.create(
              :first_name => current_user.first_name,
              :last_name => current_user.last_name,
              :payment_method_nonce => params[:payment_method_nonce]
          )
          if customer_create_result.success?
            current_user.update_attribute(:braintree_customer_id, customer_create_result.customer.id)
            result = Braintree::Transaction.sale(
              :amount => payment_amount,
              :customer_id => customer_create_result.customer.id,
              :options => {
                :submit_for_settlement => submit_payment
              },
              :custom_fields => {
                :startdate => "#{@booking.check_in_date.strftime("%a, %d %b, %Y")}",
                :enddate   => "#{@booking.check_out_date.strftime("%a, %d %b, %Y")}",
                :host      => "#{@booking.bookee.name} (#{@booking.bookee.mobile_number})"
              }
            )
          # Process payment if failed to create customer
          else
            result = Braintree::Transaction.sale(
              :amount => payment_amount,
              :payment_method_nonce => params[:payment_method_nonce],
              :options => {
                :submit_for_settlement => submit_payment
              },
              :custom_fields => {
                :startdate => "#{@booking.check_in_date.strftime("%a, %d %b, %Y")}",
                :enddate   => "#{@booking.check_out_date.strftime("%a, %d %b, %Y")}",
                :host      => "#{@booking.bookee.name} (#{@booking.bookee.mobile_number})"
              }
            )
          end
        else
          result = Braintree::Transaction.sale(
              :amount => payment_amount,
              :payment_method_nonce => params[:payment_method_nonce],
              :options => {
                :submit_for_settlement => submit_payment
              },
              :custom_fields => {
                :startdate => "#{@booking.check_in_date.strftime("%a, %d %b, %Y")}",
                :enddate   => "#{@booking.check_out_date.strftime("%a, %d %b, %Y")}",
                :host      => "#{@booking.bookee.name} (#{@booking.bookee.mobile_number})"
              }
          )
        end

        if result.success?
          # Create Payment record
          current_user.payments.create(:booking_id => @booking.id, :user_id => current_user.id, :amount => result.transaction.amount, :braintree_token => params[:payment_method_nonce], :status => result.transaction.status, :braintree_transaction_id => result.transaction.id)
          CouponUsage.find_by_coupon_id_and_user_id(@coupon.id, current_user.id).update_attribute(:booking_id, @booking.id) if @coupon.present?
          @booking.update_attribute(:owner_accepted, true)
          # @booking.mailbox.messages.create! user_id: @booking.booker_id,
          # message_text: "[This is an auto-generated message for the Guest]\n\nGreat! You have paid for the booking!\nAll that remains is for Host to confirm his/her availability. This usually happens within a few days.\nThanks for using PetHomestay!"
          # @booking.mailbox.messages.create! user_id: @booking.bookee_id,
          # message_text: "[This is an auto-generated message for the Host]\n\nGreat! #{current_user.name} has paid for the booking!"
          @booking.mailbox.update_attributes host_read: false, guest_read: false
          render :owner_receipt, :layout => 'new_application' and return
        else
          AdminMailer.braintree_payment_failure_admin(@booking, result).deliver
          flash[:error] = result.message
          redirect_to action: :edit and return
        end
      else
        current_user.find_or_create_transaction_by(@booking)
      end
    end
  end

  def show
    @booking = Booking.find(params[:id])
    redirect_to root_path and return unless current_user == @booking.booker || current_user == @booking.bookee
    @booking.remove_notification if @booking.host_accepted? && @booking.owner_view?(current_user)
  end

  def result
    if @transaction.errors.blank?
      # PetOwnerMailer.booking_receipt(@transaction.booking).deliver
      ProviderMailer.owner_confirmed(@transaction.booking).deliver
      return redirect_to booking_path(@transaction.booking, confirmed_by: 'guest')
    else
      return redirect_to(new_booking_path(homestay_id: @transaction.booking.homestay.id), alert: @transaction.error_messages)
    end
  end

  def host_confirm
    @booking = current_user.bookees.find_by_id(params[:id])
    # @booking.confirmed_by_host() if @booking.enquiry.proposed_per_day_price.present?
    if @booking.state?(:guest_cancelled)
      flash[:notice] = "This booking has been canceled by the guest"
    elsif @booking.state?(:host_cancelled)
      flash[:notice] = "This booking has now been canceled by the admin as requested"
    elsif @booking.state?(:host_requested_cancellation)
      flash[:notice] = "You have requested to cancel this booking"
    end
    render layout: 'new_application'
  end

  def book_reservation
    @booking = Booking.find(params[:id])
    @booking.update_attributes(params[:booking])
    @booking.enquiry.update_attribute(:owner_accepted, true)
    try_pay = @booking.try_payment #try to upgrade status

    respond_to do |format|
      #return status back for debugging
      msg = { :status => try_pay == true ? "ok" : "fail", :message => try_pay == true ? "Success!" : "failed" }
      format.json  { render :json => msg }
    end
  end

  def host_message
    @booking = Booking.find(params[:id])
    @booking.remove_notification
    redirect_to mailbox_messages_path(@booking.mailbox)
  end

  def update_transaction
    booking = Booking.find(params[:booking_id])
    unavailable_dates = booking.bookee.unavailable_dates_between(params[:check_in_date].to_date, params[:check_out_date].to_date)
    if unavailable_dates.blank?
      transaction_payload = booking.update_transaction_by(params[:number_of_nights], params[:check_in_date], params[:check_out_date])
      return render json: transaction_payload
    else
      unavailable_dates.collect!{ |date| date.strftime('%d/%m/%Y') }
      render json: { error: t("booking.unavailable", dates: unavailable_dates.join(", ")) }, status: 400
    end
  end

  def update_message
    booking = Booking.find(params[:booking_id])
    booking.check_in_time = params[:check_in_time]
    booking.check_out_time = params[:check_out_time]
    unavailable_dates = booking.bookee.unavailable_dates_between(params[:check_in_date].to_date, params[:check_out_date].to_date)
    if unavailable_dates.blank?
      booking.message_update(params[:message])
      render nothing: true
    else
      unavailable_dates.collect!{ |date| date.strftime('%d/%m/%Y') }
      render json: { error: t("booking.unavailable", dates: unavailable_dates.join(", ")) }, status: 400
    end
  end

  def guest_cancelled
    @booking = Booking.find(params[:id])
    if @booking.is_host_view_valid?
      @account = current_user.account
      if @account.nil?
        @account = Account.new
      end
    else
      if @booking.transaction
        @booking.transaction.destroy #remove any associated transaction
      end
      @booking.destroy
      flash[:notice] = 'Your incomplete booking was cancelled.'
      if current_user.homestay.present?
        redirect_to host_bookings_path and return
      else
        redirect_to guest_messages_path and return
      end
    end
  end

  def host_paid
    @booking = Booking.find(params[:id])
    # @booking.host_was_paid
    # @booking.save!
    @booking.update_column(:state, "host_paid")
    render nothing: true
  end

  def guest_refunded
    @booking = Booking.find(params[:id])
    @booking.refunded.nil? ? @booking.refunded = true : @booking.refunded = !@booking.refunded
    @booking.save!
    render nothing: true
  end

  def admin_view
    redirect_to root_path, notice: 'Sorry, No access' and return unless current_user.admin
    @booking = Booking.find(params[:id])
  end

  def host_cancellation
    @booking = current_user.bookees.find_by_id(params[:booking_id])
    redirect_to host_path, notice: "Sorry, something went wrong" and return if @booking.nil?
    render 'host_cancel'
  end

  def host_cancel
    @one_booking = current_user.bookees.length == 1 ? true : false
    @booking_errors = ""
    @booking = Booking.find(params[:booking]['cancelled_booking'])
  end

  def host_confirm_cancellation
    @booking = current_user.bookees.find_by_id(params[:id])
    redirect_to host_path, notice: "Sorry, something went wrong" and return if @booking.nil?
    if params[:booking][:cancel_reason].blank?
      @booking_errors = "Cancel reason cannot be blank!"
      render 'host_cancel'
    else
      # ensure that we can search for this status when showing the admin notifications
      @booking.cancel_reason = params[:booking][:cancel_reason]
      @booking.save
      @booking.update_column(:state, 'host_requested_cancellation')
      flash[:notice] = "Your request to cancel this booking has been forwarded to the admin for approval."
      return redirect_to host_messages_path
    end
  end

  def guest_save_cancel_reason
    @booking = Booking.find(params[:id])
    @booking_errors = nil
    if params[:booking][:cancel_reason].blank?
      @booking_errors = "Cancel reason cannot be blank!"
    else
      @booking.cancel_reason = params[:booking][:cancel_reason]
      @booking.save
    end
    if (@booking.calculate_refund == "0.00" and @booking_errors.nil?)
      canceled(params[:id], false)
      render :js => "window.location = '#{trips_bookings_path}'"
    else
      respond_to do | format|
        format.js
      end
    end
  end

  private
  def homestay_required
    if params[:enquiry_id].blank? && params[:homestay_id].blank?
      return redirect_to guest_path, alert: 'You are not authorised to make this request!'
    end
    @enquiry = current_user.enquiries.find(params[:enquiry_id]) unless params[:enquiry_id].blank?
    @homestay = params[:homestay_id].blank? ? @enquiry.homestay : Homestay.find(params[:homestay_id])
  end
end
