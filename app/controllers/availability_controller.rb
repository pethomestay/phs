class AvailabilityController < ApplicationController

  before_filter :authenticate_user!

  def show
    @homestay = Homestay.find_by_slug(params[:id])
  end
end

