require './app/models/search'

class PagesController < ApplicationController
  def home
  end

  def test
    render text: request.ip
  end
end
