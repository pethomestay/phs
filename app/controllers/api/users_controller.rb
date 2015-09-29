class Api::UsersController < Api::BaseController

  # User registration.
  # @url /users
  # @action POST
  def create
    @user = User.new(params[:user])
    if @user.save
      # Login?
    else
      render_400 @user.errors.full_messages
    end
  end

end
