class AvailabilityController < ApplicationController

  before_filter :authenticate_user!

  def show
    @homestay = Homestay.find_by_slug(params[:id])
    test = 1

    #@booking.remove_notification if @booking.host_accepted? && @booking.owner_view?(current_user)
  end
end

