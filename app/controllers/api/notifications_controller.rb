class Api::NotificationsController < Api::BaseController

  before_filter :authenticate_user

  def create
  end

  def register
    begin
      @device = Device.register(@user, params[:device][:token], params[:device][:name])
    rescue ArgumentError => e
      render_400 e.message
    end
  end

end
