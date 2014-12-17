class Admin::CouponsController < Admin::AdminController
  respond_to :html

  def index
    @coupon = Coupon.new
    # @coupons = Coupon.all.group_by(&:user_id)
    @applied_coupons = CouponUsage.all
    @expired_coupons = Coupon.invalid
  end

  def create_coupon
    params[:coupon][:code].upcase!
    @coupon = Coupon.new(params[:coupon])
    if @coupon.save
      redirect_to admin_coupons_path
    else
      @applied_coupons = CouponUsage.all
      render :index, :error => @coupon.errors.messages
    end
  end

  def expire_coupon
    @expiring_coupon = Coupon.find(params[:expiring_coupon][:id])
    if @expiring_coupon.nil?
      render :json => { :success => false, :error => "No coupon found"}
    elsif @expiring_coupon.update_attribute(:coupon_limit, @expiring_coupon.users.count)
      render :json => { :success => true, :message => "Coupon successfully expired"}
    else
      render :json => { :success => false, :error => "Miscellaneous error"}
    end
  end

end
