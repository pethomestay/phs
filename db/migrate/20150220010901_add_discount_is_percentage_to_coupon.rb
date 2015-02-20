class AddDiscountIsPercentageToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :discount_is_percentage, :boolean, :default => false
  end
end
