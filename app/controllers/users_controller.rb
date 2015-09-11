class UsersController < ApplicationController
  before_filter :authenticate_user!

  def set_coupon
    if current_user.used_coupons.any?
      @message = "You have already applied a previous coupon"
    else
      coupon = Coupon.valid.find_by_code params[:user][:coupon_code].to_s.upcase

      if coupon && coupon.valid_for?(current_user)
        CouponUsage.create(user: current_user, coupon: coupon)
        @message = "Thanks, the coupon has been accepted, it will be applied the first time you make a booking"
        flash[:notice] = @message
        cookies[:code] = nil
        session[:check_for_coupon] = nil
      else
        @message = "Sorry, the coupon is not valid"
      end
      params[:user][:coupon_code] = nil
    end
    respond_to do |format|
      format.html { redirect_to root_path, :notice => @message }
      format.js { render :action => :set_coupon, :layout => false }
    end
  end

  # Clears session variable
  def decline_coupon
    session[:check_for_coupon] = nil
    render json: :ok
  end
end
