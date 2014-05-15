class UnavailableDatesController < ApplicationController

  before_filter :authenticate_user!

  def create
    unavailable_date = current_user.unavailable_dates.new(unavailable_date_params)
    if unavailable_date.save
      render json: { message: t("unavailable_date.successfully_created"), id: unavailable_date.id }, status: 200
    else
      render json: { message: unavailable_date.errors.messages }, status: 400
    end
  end

  def destroy
    unavailable_date = current_user.unavailable_dates.find(params[:id])
    unavailable_date.destroy
    render json: { message: t("unavailable_date.successfully_destroyed") }, status: 200
  end

  private

  def unavailable_date_params
    params.require(:unavailable_date).permit(:date)
  end

end
