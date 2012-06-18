require './app/models/search'

class PagesController < ApplicationController
  def home
  end

  def test
    raise env.inspect
  end
end
