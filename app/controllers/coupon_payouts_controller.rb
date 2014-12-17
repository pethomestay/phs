class CouponPayoutsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_required, except: :new

  # Allows users to request coupon payouts
  def new
    current_user.coupon_payouts.create(:payment_amount => current_user.coupon_credits_earned)
    if current_user.homestay.present?
      redirect_to new_host_account_path, alert: "Thanks, we will process the request shortly"
    else 
      redirect_to new_guest_account_path, alert: "Thanks, we will process the request shortly"
    end
  end

  # Admin to mark a request as completed
  def update
    @coupon_payout = CouponPayout.unpaid.find(params[:id])
    redirect_to admin_bookings_path and return if @coupon_payout.nil?
    @coupon_payout.update_attribute(:paid, true)
    redirect_to admin_bookings_path, alert: "#{@coupon_payout.payment_amount} paid to #{@coupon_payout.user.name}"
  end


  private

  def admin_required
   redirect_to root_path unless current_user.admin?
  end

end
