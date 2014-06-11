class BookingsController < ApplicationController
	before_filter :authenticate_user!
	before_filter :homestay_required, only: :new
	before_filter :secure_pay_response, only: :result

	def index
		@bookings = current_user.bookees.valid_host_view_booking_states
	end

	def new
		@booking = current_user.find_or_create_booking_by(@enquiry, @homestay)
		@transaction = current_user.find_or_create_transaction_by(@booking)
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
  end

  def book_reservation
    @booking = Booking.find(params[:id])
    if @booking.state?(:unfinished)
      @booking.try_payment #try pay
    end
    respond_to do |format|
      msg = { :status => "ok", :message => "Success!", :html => "<b>...</b>" }
      format.json  { render :json => msg } # don't do msg.to_json
    end
=begin
    uri = URI(ENV['TRANSACTION_POST_ACTION'])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.set_debug_output $stderr

    request = Net::HTTP::Post.new(uri.request_uri)
   # "utf8"=>"✓", "authenticity_token"=>"eFO2gJyZxHL+aiKfmEfm7r1t9ylDij5VbMqugfAqzvU=", "EPS_MERCHANT"=>"EHY0047", "EPS_TXNTYPE"=>"1", "EPS_REFERENCEID"=>"transaction_id=101", "EPS_AMOUNT"=>"23.08", "EPS_RESULTURL"=>"bookings/result?authenticity_token=eFO2gJyZxHL+aiKfmEfm7r1t9ylDij5VbMqugfAqzvU=", "EPS_REDIRECT"=>"TRUE", "EPS_TIMESTAMP"=>"20140610060743", "EPS_FINGERPRINT"=>"ce9748ac46b9e3a550acc91c3f5a3b7bfc05bb4b", "securepay_transaction_action"=>"https://api.securepay.com.au/test/directpost/authorise", "stored_card_transaction_action"=>"/bookings/91/book_reservation", "transaction"=>{"store_card"=>"0"}, "EPS_CARDNUMBER"=>"4444333325221111", "EPS_CCV"=>"123", "EPS_EXPIRYMONTH"=>"1", "EPS_EXPIRYYEAR"=>"2016", "id"=>"91"}
    #params.delete :utf8
    #params.delete :authenticity_token
    #params.delete :securepay_transaction_action
    #params.delete :transaction
    #params.delete :id
    #params.delete :_method
    #params.delete :action
    #params.delete :controller
    #params.delete :stored_card_transaction_action

    request.set_form_data(params)

# Tweak headers, removing this will default to application/x-www-form-urlencoded
    request["Content-Type"] = "application/json"
    #res = Net::HTTP.post_form(uri, params)
    res = http.request(request)
    puts res.body
=end
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

	def host_paid

		@booking = Booking.find(params[:id])
    @booking.host_paid
		@booking.save!
		render nothing: true
	end

	def trips
		@bookings = current_user.bookers.order('created_at DESC')
	end

	def admin_view
		@booking = Booking.find(params[:id])
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