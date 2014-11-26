class Guest::AccountsController < Guest::GuestController
  include BookingsHelper

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(params[:account])
    @account.user = current_user
    if @account.save
      if @account.user.homestay.present?
        redirect_to host_account_path
      else
        redirect_to guest_account_path
      end
    else
      render :new
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
      redirect_to guest_account_path
    else
      render :edit
    end
  end

  def show
    @account = current_user.account
  end
end
