class HotelsController < ApplicationController
  def show
    @hotel = Hotel.find(params[:id])
    @reviewed_ratings = @hotel.ratings.reviewed
  end
end
