class Host::AccountsController < Host::HostController
  include BookingsHelper

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(params[:account])
    if @account.save
      render :show
    else
      render :new
    end
  end

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

  def edit
    @account = current_user.account
  end

  def update
    @account = current_user.account
    if @account.update_attributes(params[:account])
      flash[:notice] = 'Your account details have been saved'
      if params.has_key?(:booking_id)
        canceled params[:booking_id], false
      end
      render :show
    else
      render :edit
    end
  end

  def show
    @account = current_user.account
  end
end
