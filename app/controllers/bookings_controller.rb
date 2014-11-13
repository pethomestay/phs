class BookingsController < ApplicationController
  include BookingsHelper
  before_filter :authenticate_user!
  before_filter :homestay_required, only: [:index, :new]
  before_filter :secure_pay_response, only: :result

  def index
    @bookings = current_user.bookees.valid_host_view_booking_states
  end

  def new
    @booking = current_user.find_or_create_booking_by(@enquiry, @homestay)
    redirect_to edit_booking_path(@booking)
  end

  def edit
    @booking = current_user.bookees.find_by_id(params[:id]) || current_user.bookers.find_by_id(params[:id])
    return redirect_to root_path, :alert => "Sorry no booking found" if @booking.nil?
    @host_view = @booking.bookee == current_user
    if !@host_view
      if current_user.used_coupon.present? && current_user.used_coupon.booking.nil? && current_user.admin
        @coupon = current_user.used_coupon
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
    redirect_to guest_path, :notice => "Sorry no receipt found" and return if @booking.nil?
    render :owner_receipt, :layout => 'new_application'
  end

  def host_receipt
    @booking = current_user.bookees.find_by_id(params[:booking_id])
    redirect_to host_path, :notice => "Sorry no receipt found" if @booking.nil?
    render :host_receipt, :layout => 'new_application'
  end

  def update
    @booking = current_user.bookees.find_by_id(params[:id]) || current_user.bookers.find_by_id(params[:id])
    if @booking.bookee == current_user # Host booking modifications
      if @booking.owner_accepted
        @booking.update_attributes!(params[:booking])
        if params[:booking][:host_accepted] == "false"
          Raygun.track_exception(custom_data: {time: Time.now, user: current_user.id, reason: "Host rejected a paid booking #{@booking.id}"})
          AdminMailer.host_rejected_paid_booking(@booking).deliver
          @booking.mailbox.messages.create! user_id: @booking.booker_id,
          message_text: "[This is an auto-generated message for the Guest]\n\nUnfortunately #{current_user.name} has declined the booking. You can try other Hosts in your area.\n\n#{params[:booking][:message]}"
          @booking.mailbox.messages.create! user_id: @booking.bookee_id,
          message_text: "[This is an auto-generated message for the Host]\n\nYou have declined the booking.\n\n#{params[:booking][:message]}"
          return redirect_to host_path, :alert => "Informed #{@booking.booker.name} of rejected booking"
        else
          message = @booking.confirmed_by_host(current_user)
          return redirect_to host_path, alert: message
        end
      else
        if @booking.update_attributes!(params[:booking])
          @booking.update_transaction_by_daily_price(params[:booking][:cost_per_night])
          @booking.mailbox.messages.create user_id: @booking.bookee_id,
          message_text: "[This is an auto-generated message for the Host]\n\nCustom Rate proposed to #{@booking.booker.first_name} for #{view_context.number_to_currency(@booking.amount)} for #{@booking.number_of_nights} days."
          @booking.mailbox.messages.create user_id: @booking.booker_id,
          message_text: "[This is an auto-generated message for the Guest]\n\n#{current_user.first_name} has proposed a custom rate at #{view_context.number_to_currency(@booking.amount)} in total. Go ahead and book this Homestay if you're happy with it.\n\n#{params[:booking][:message]}"
          @booking.mailbox.messages.create(:user_id => current_user.id, :message_text => params[:booking][:message]) unless params[:booking][:message].blank?
          @booking.update_attribute(:host_accepted, true)
          return redirect_to host_path, alert: "Details sent to #{@booking.booker.name}"
        else
          return redirect_to host_path
        end
      end
    else # Guest booking modifications (or payment)
      if current_user.used_coupon.present? && current_user.used_coupon.booking.nil? && current_user.admin
        @coupon = current_user.used_coupon
        payment_amount = (@booking.amount - @coupon.discount_amount).to_s
      else
        payment_amount = @booking.amount.to_s
      end
      submit_payment = @booking.host_accepted == true ? true : false
      if params[:payment_method_nonce].present? # Payment was made
        final_amount = @booking.coupon.present? ? @booking.amount - @booking.coupon.discount_amount : @booking.amount
        # Create a customer in BrainTree if the user has never paid via BrainTree before
        if current_user.braintree_customer_id.nil?
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
              :descriptor => {
                :name => "Stay #{@booking.check_in_date.strftime("%-d/%-m/%y")} - #{@booking.check_out_date.strftime('%-d/%-m/%y')}",
                :phone => "1300660945",
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
              :descriptor => {
                :name => "Stay #{@booking.check_in_date.strftime("%-d/%-m/%y")} - #{@booking.check_out_date.strftime('%-d/%-m/%y')}",
                :phone => "1300660945",
              },
              :custom_fields => {
                :startdate => "#{@booking.check_in_date.strftime("%a, %d %b, %Y")}",
                :enddate   => "#{@booking.check_out_date.strftime("%a, %d %b, %Y")}",
                :host      => "#{@booking.bookee.name} (#{@booking.bookee.mobile_number})"
              }
            )
            Raygun.track_exception(custom_data: {time: Time.now, user: current_user.id, reason: "BrainTree customer creation failed"})
          end
        else
          result = Braintree::Transaction.sale(
              :amount => payment_amount,
              :payment_method_nonce => params[:payment_method_nonce],
              :options => {
                :submit_for_settlement => submit_payment
              },
              :descriptor => {
                :name     => "Stay #{@booking.check_in_date.strftime("%-d/%-m/%y")} - #{@booking.check_out_date.strftime('%-d/%-m/%y')}",
                :phone    => "1300660945",
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
          @coupon.update_attribute(:booking_id, @booking.id) if @coupon.present?
          @booking.update_attribute(:owner_accepted, true)
          @booking.mailbox.messages.create! user_id: @booking.booker_id,
          message_text: "[This is an auto-generated message for the Guest]\n\nGreat! You have paid for the booking!\nAll that remains is for Host to confirm his/her availability. This usually happens within a few days.\nThanks for using PetHomestay!"
          @booking.mailbox.messages.create! user_id: @booking.bookee_id,
          message_text: "[This is an auto-generated message for the Host]\n\nGreat! #{current_user.name} has paid for the booking!"
          render :owner_receipt, :layout => 'new_application' and return
        else
          Raygun.track_exception(custom_data: {time: Time.now, user: current_user.id, reason: "BrainTree payment failed", result: result, booking_id: @booking.id})
          AdminMailer.braintree_payment_failure_admin(@booking, result).deliver
          render :edit, :layout => 'new_application' and return
        end
      else
        current_user.find_or_create_transaction_by(@booking)
      end
    end
  end

  def show
    @booking = Booking.find(params[:id])
    @booking.remove_notification if @booking.host_accepted? && @booking.owner_view?(current_user)
  end

  def result
    if @transaction.errors.blank?
      PetOwnerMailer.booking_receipt(@transaction.booking).deliver
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
      return redirect_to trips_bookings_path
    end
  end

  def host_paid
    @booking = Booking.find(params[:id])
    @booking.host_was_paid
    @booking.save!
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
    #list of bookings that the host can request to cancel
    @bookings = Booking.where("bookee_id = ? AND state = ? AND check_in_date >= ?", current_user.id, :finished_host_accepted, Date.today)
    if @bookings.length == 1
      @one_booking = true
      @booking = @bookings.first
      render 'host_cancel'
    end
  end

  def host_cancel
    @one_booking = current_user.bookees.length == 1 ? true : false
    @booking_errors = ""
    @booking = Booking.find(params[:booking]['cancelled_booking'])
  end

  def host_confirm_cancellation
    @booking = Booking.find(params[:id])
    if params[:booking][:cancel_reason].blank?
      @booking_errors = "Cancel reason cannot be blank!"
      render 'host_cancel'
    else
      # ensure that we can search for this status when showing the admin notifications
      @booking.host_requested_cancellation
      @booking.cancel_reason = params[:booking][:cancel_reason]
      @booking.save
      flash[:notice] = "Your request to cancel this booking has been forwarded to the admin for approval."
      return redirect_to host_path
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
      return redirect_to my_account_path, alert: 'You are not authorised to make this request!'
    end
    @enquiry = current_user.enquiries.find(params[:enquiry_id]) unless params[:enquiry_id].blank?
    @homestay = params[:homestay_id].blank? ? @enquiry.homestay : Homestay.find(params[:homestay_id])
  end

  def secure_pay_response
    invalid_response = %w(timestamp summarycode refid fingerprint restext rescode txnid preauthid)
      .inject(false) { |boolean, key| boolean || params[key].blank? }
    return redirect_to my_account_path, alert: 'This transaction is not authorized' if invalid_response
    response = {
      time_stamp: params['timestamp'],
      summary_code: params['summarycode'],
      reference_id: params['refid'],
      fingerprint: params['fingerprint'],

      card_storage_response_code: params['strescode'],
      card_number: params['pan'],
      token: params['token'],
      card_storage_response_text: params['strestext'],

      response_text: invalid_response ? 'Something has went wrong, please contact support' : params['restext'],
      response_code: invalid_response ? 'invalid' : params['rescode'],
      transaction_id: params['txnid'],
      pre_authorization_id: params['preauthid']
    }
    @transaction = Transaction.find(response[:reference_id].split('=')[1]).update_by_response(response)
  end
end
