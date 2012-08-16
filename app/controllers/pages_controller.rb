require './app/models/search'

class PagesController < ApplicationController
  def home
  end

  def welcome
    unless current_user
      redirect_to root_path
      return
    end
  end

  def test
    render json: {
      ip: request.ip,
      forwardedFor: env['HTTP_X_FORWARDED_FOR'],
      remoteAddr: env['REMOTE_ADDR'],
      clientIP: env['HTTP_CLIENT_IP']
    }
  end
end
