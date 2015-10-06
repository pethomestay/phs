class Api::UsersController < Api::BaseController

  # User registration.
  # @url /users
  # @action POST
  def create
    @user = User.new(params[:user])
    if @user.save
      @user.record_device(params[:device])
      @user.record_oauth(params[:oauth])
    else
      render_400 @user.errors.full_messages
    end
  end

end
