class AvailabilityController < ApplicationController

  before_filter :authenticate_user!

  def show
    @homestay = Homestay.find_by_slug(params[:id])
  end

  def booking_info
    start_date = Time.at(params[:start].to_i).to_date
    end_date  = Time.at(params[:end].to_i).to_date
    unavailable_dates = current_user.unavailable_dates.between(start_date, end_date)
    booking_info = unavailable_dates.collect do |unavailable_date|
      {
        id: unavailable_date.id,
        title: "Unavailable",
        start: unavailable_date.date.strftime("%Y-%m-%d"),
        end: unavailable_date.date.strftime("%Y-%m-%d")
      }
    end
    ((start_date..end_date).to_a - unavailable_dates.map(&:date)).each do |date|
      booking_info << { 
        title: "Available",
        start: date.strftime("%Y-%m-%d"),
        end: date.strftime("%Y-%m-%d")
      }
    end
    render json: booking_info.to_json, status: 200
  end

end

