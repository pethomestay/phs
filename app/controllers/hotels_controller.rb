class HotelsController < ApplicationController
  def show
  	@hotel = Homestay.all.first
  end
end
