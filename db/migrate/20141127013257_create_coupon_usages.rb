class CreateCouponUsages < ActiveRecord::Migration
  def change
    create_table :coupon_usages do |t|
      t.boolean :coupon_status
      t.references :user
      t.references :coupon
      t.references :booking

      t.timestamps
    end
    add_index :coupon_usages, :user_id
    add_index :coupon_usages, :coupon_id
    add_index :coupon_usages, :booking_id
  end
end
