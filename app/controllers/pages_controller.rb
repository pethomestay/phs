require './app/models/search'

class PagesController < ApplicationController
  def home
  end

  def test
    render json: {
      ip: request.ip,
      forwardedFor: env['HTTP_X_FORWARDED_FOR']
    }
  end
end
