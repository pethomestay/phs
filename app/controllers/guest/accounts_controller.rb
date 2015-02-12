class Guest::AccountsController < Guest::GuestController
  include BookingsHelper

  def new
    if current_user.account
      @account = current_user.account
      redirect_to edit_guest_account_path
    else
      @account = Account.new
    end
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
    redirect_to new_guest_account_path and return if current_user.account.nil?
    @account = current_user.account
  end

  def update
    redirect_to new_guest_account_path and return if current_user.account.nil?
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
    redirect_to new_guest_account_path and return if current_user.account.nil?
    @account = current_user.account
  end
end
