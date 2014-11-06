class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.integer :payment_id
      t.integer :referrer_id
      t.integer :used_by_id
      t.decimal :discount_amount
      t.decimal :credit_referrer_amount
      t.date :valid_from
      t.date :valid_to

      t.timestamps
    end
  end
end
