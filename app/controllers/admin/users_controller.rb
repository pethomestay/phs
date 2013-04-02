class Admin::UsersController < Admin::AdminController
  respond_to :html

  def index
    respond_with(:admin, @users = User.order('created_at DESC'))
  end

  def show
    respond_with(:admin, @user = User.find(params[:id]))
  end

  def new
    respond_with(:admin, @user = User.new)
  end

  def edit
    respond_with(:admin, @user = User.find(params[:id]))
  end

  def create
    respond_with(:admin, @user = User.create(params[:user]))
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    respond_with(:admin, @user)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_with(:admin, @user)
  end
end
