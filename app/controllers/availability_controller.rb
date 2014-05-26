class AvailabilityController < ApplicationController

  before_filter :authenticate_user!

  def show
    @homestay = Homestay.find_by_slug(params[:id])
  end

  def booking_info
    info = current_user.booking_info_between(params[:start].to_date, params[:end].to_date)
    render json: info.to_json, status: 200
  end

end

