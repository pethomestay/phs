class UnavailableDatesController < ApplicationController

  before_filter :authenticate_user!

  def create
    if current_user.admin && params[:user_id].present? && params[:from].present? && params[:to].present?
      from = Date.parse(params[:from])
      to   = Date.parse(params[:to])
      user = User.find(params[:user_id])
      for date in (from..to)
        user.unavailable_dates.create date: date
      end
      head :ok
    else
      unavailable_date = current_user.unavailable_dates.new(unavailable_date_params)
      if unavailable_date.save
        render json: { message: t("unavailable_date.successfully_created"), id: unavailable_date.id }, status: 200
      else
        render json: { message: unavailable_date.errors.messages }, status: 400
      end
    end
  end

  def destroy
    if current_user.admin && params[user_id].present?
      unavailable_date = User.find(params[:user_id]).unavailable_dates.find(params[:id])
    else
      unavailable_date = current_user.unavailable_dates.find(params[:id])
    end
    unavailable_date.destroy
    render json: { message: t("unavailable_date.successfully_destroyed") }, status: 200
  end

  private

  def unavailable_date_params
    params.require(:unavailable_date).permit(:date, :user_id)
  end

end
