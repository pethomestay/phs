class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = current_user
  end

  def set_coupon
    current_user.validate_code(params[:user][:coupon_code])
    if current_user.used_coupon.present?
      message = "Thanks, the coupon has been accepted, it will be applied the first time you make a booking"
    else
      message = "Sorry, the coupon is not valid"
    end
    binding.pry
    render root_path, :notice => message
  end

  def update_calendar
    current_user.update_calendar
    render json: { message: "Successfully Updated" }, status: 200
  end
end
