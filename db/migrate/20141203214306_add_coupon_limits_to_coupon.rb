class AddCouponLimitsToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :coupon_limit, :integer
    add_column :coupons, :users_count, :integer, :default => 0
  end
end
