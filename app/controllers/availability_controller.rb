# Depreciated
class AvailabilityController < ApplicationController

  before_filter :authenticate_user!

  def show
    @homestay = Homestay.find_by_slug(params[:id])
  end

  def booking_info
    start_date = Time.at(params[:start].to_i).to_date
    end_date  = Time.at(params[:end].to_i).to_date
    info = current_user.booking_info_between(start_date, end_date)
    render json: info.to_json, status: 200
  end

end

