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

  def mass_assign_coupon_code


  end

  def do_mass_assign_coupon_code
    @coupon = Coupon.find_by_code(params[:coupon_code])
    render :mass_assign_coupon_code, flash[:error] => "Coupon Code not recognised" and return unless @coupon
    emails = params[:email].split(",")
    target_users = []
    emails.each do |email|
      temp_user = User.find_by_email(email.strip)
      target_users << temp_user unless temp_user.used_coupons.find_by_code(@coupon.code)
    end
    target_users.compact.uniq.each {|u| u.used_coupons << @coupon}
    redirect_to admin_coupons_path, :notice => "#{@coupon.code} applied to #{target_users.count} users (#{target_users.collect(&:email).join(", ")})"
  end

end
