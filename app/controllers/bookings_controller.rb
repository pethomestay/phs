class BookingsController < ApplicationController
  include BookingsHelper
	before_filter :authenticate_user!
	before_filter :homestay_required, only: :new
	before_filter :secure_pay_response, only: :result

	def index
		@bookings = current_user.bookees.valid_host_view_booking_states
	end

	def new
		@booking = current_user.find_or_create_booking_by(@enquiry, @homestay)
		@transaction = current_user.find_or_create_transaction_by(@booking)
    if @booking.state?(:payment_authorisation_pending) #we have tried to pay for this booking before display the ring admin screen
      PaymentFailedJob.new.async.perform(@booking, @transaction)
      render "bookings/payment_issue"
    end
	end

	def update
		@booking = Booking.find(params[:id])
		if @booking.update_attributes!(params[:booking])
			message = @booking.confirmed_by_host(current_user)
			return redirect_to my_account_path, alert: message
		else
			return redirect_to host_confirm_booking_path(@booking)
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
		@booking = Booking.find(params[:id])
    if @booking.state?(:guest_cancelled)
      flash[:notice] = "This booking has been canceled by the guest"
    elsif @booking.state?(:host_cancelled)
      flash[:notice] = "This booking has now been canceled by the admin as requested"
    elsif @booking.state?(:host_requested_cancellation)
      flash[:notice] = "You have requested to cancel this booking"
    end
	end

  def book_reservation
    @booking = Booking.find(params[:id])
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
		transaction_payload = booking.update_transaction_by(params[:number_of_nights], params[:check_in_date], params[:check_out_date])
		return render json: transaction_payload
	end

	def update_message
		booking = Booking.find(params[:booking_id])
		booking.check_in_time = params[:check_in_time]
		booking.check_out_time = params[:check_out_time]
		booking.message_update(params[:message])
		render nothing: true
  end

  def guest_canceled
    @booking = Booking.find(params[:id])
    @account = current_user.account
    if @account.nil?
      @account = Account.new
    end
  end

	def host_paid

		@booking = Booking.find(params[:id])
    @booking.host_paid
		@booking.save!
		render nothing: true
  end

  def guest_refunded
    @booking = Booking.find(params[:id])
    @booking.refunded.nil? ? @booking.refunded = true : @booking.refunded = !@booking.refunded
    @booking.save!
    render nothing: true
  end

	def trips
		@bookings = current_user.bookers.order('created_at DESC')
	end

	def admin_view
		@booking = Booking.find(params[:id])
  end

  def host_cancellation
    #list of bookings that the host can request to cancel
    @bookings = Booking.where("bookee_id = ? AND state in (?) AND check_in_date >= ?", current_user.id, [:finished, :finished_host_accepted], Date.today)
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
      return redirect_to my_account_path
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
    if (@booking.calculate_refund == 0 and @booking_errors.nil?)
      canceled (params[:id], false)
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