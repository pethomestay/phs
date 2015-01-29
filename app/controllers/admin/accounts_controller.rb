class Admin::AccountsController < Admin::AdminController
  respond_to :html

  def new
  end

  def edit
    respond_with(:admin, @user = User.find(params[:id]))
  end

  def create
    @account = Account.new(params[:account])
    if @account.save
      redirect_to admin_user_path(@account.user), :notice => "Account created"
    else
      @user = User.find(params[:account][:user_id])
      redirect_to admin_user_path(@user), :alert => "Error: #{@account.errors.messages}"
    end
  end

  def update
    @account = Account.find(params[:id])
    if @account.update_attributes!(params[:account])
      redirect_to admin_user_path(@account.user), :notice => "Account updated"
    else
      redirect_to admin_user_path(@account.user), :alert => "Error: #{@account.errors.messages}"
    end
  end

  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    redirect_to admin_user_path(@account.user), :notice => "Account deleted"
  end
end
