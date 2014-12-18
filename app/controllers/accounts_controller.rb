class AccountsController < ApplicationController
  include BookingsHelper
  before_filter :authenticate_user!

  def guest_cancel_save_account_details
    @account = Account.new(params[:account])
    if @account.save
      canceled params[:booking_id], false

      flash[:notice] = 'Your account details have been saved'
      return redirect_to trips_bookings_path
    else
      @booking = Booking.find(params[:booking_id])
      render 'bookings/guest_cancelled'
    end
  end
end
