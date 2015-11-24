class Api::NotificationsController < Api::BaseController

  before_filter :authenticate_user, only: :register

  def create
    @device_token = params[:device_token]
    APN.notify_async(@device_token, params[:notification])
  end

  def register
    begin
      @device = Device.register(@user, params[:device][:token], params[:device][:name])
    rescue ArgumentError => e
      render_400 e.message
    end
  end

end
