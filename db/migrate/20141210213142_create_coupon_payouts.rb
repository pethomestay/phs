class CreateCouponPayouts < ActiveRecord::Migration
  def change
    create_table :coupon_payouts do |t|
      t.references :user
      t.decimal :payment_amount
      t.boolean :paid

      t.timestamps
    end
    add_index :coupon_payouts, :user_id
  end
end
