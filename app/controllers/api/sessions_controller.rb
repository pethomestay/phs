class Api::SessionsController < Api::BaseController

  # User login.
  # @url /sessions
  # @action POST
  def create
    if params[:email].blank? || params[:password].blank?
      render_400 'Email and password are both required.'
    else
      @user = User.where(email: params[:email]).first
      if @user.blank? || !@user.valid_password?(params[:password])
        render_404 'Invalid email or password.'
      end
    end
  end

end
