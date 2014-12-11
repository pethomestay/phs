class UsersController < ApplicationController
  before_filter :authenticate_user!

  def set_coupon
    redirect_to root_path, :notice => "You have already applied a previous coupon" and return if current_user.used_coupons.any?
    if current_user.validate_code?(params[:user][:coupon_code])
      message = "Thanks, the coupon has been accepted, it will be applied the first time you make a booking"
    else
      message = "Sorry, the coupon is not valid"
    end
    params[:user][:coupon_code] = nil
    redirect_to root_path, :notice => message and return
  end
end
