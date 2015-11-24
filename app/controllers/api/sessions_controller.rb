class Api::SessionsController < Api::BaseController

  # User login.
  # @url /sessions
  # @action POST
  def create
    if authentication_supplied?
      @user = User.where(email: params[:email]).first
      if @user.present? && authentication_valid?
        @user.record_device(params[:device])
        @user.record_oauth(params[:oauth])
      else
        render_404 'Invalid authentication params.'
      end
    else
      render_400 'Incomplete authentication params.'
    end
  end

  private

  # Checks if the required authentication params are present.
  # @api private
  # @return [Boolean]
  def authentication_supplied?
    params[:email] && (params[:password] || (params[:oauth] && params[:oauth][:token]))
  end

  # Checks if the authentication attempt succeeded or not.
  # @api private
  # @return [Boolean]
  def authentication_valid?
    if params[:password].present?
      @user.valid_password?(params[:password])
    elsif params[:oauth] && params[:oauth][:token]
      @user.uid.blank? || @user.uid == params[:oauth][:token]
    else
      false
    end
  end

end
