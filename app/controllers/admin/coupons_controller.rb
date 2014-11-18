class Admin::CouponsController < Admin::AdminController
	respond_to :html

	def index
    @coupons = Coupon.all.group_by(&:referrer_id)
	end

end
