require './app/models/search'

class PagesController < ApplicationController
  def home
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
